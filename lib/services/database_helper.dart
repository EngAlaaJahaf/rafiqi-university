import 'package:rafiqi_university/model/subject.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// هذا هو كلاس الـ Model الذي يمثل جدول المواد
// من الأفضل وضعه في ملف منفصل مثل 'lib/models/subject.dart'


// -----------------------------------------------------------------


class DatabaseHelper {
  // 1. Singleton Pattern: لضمان وجود نسخة واحدة فقط من هذا الكلاس
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // دالة getter للحصول على قاعدة البيانات
  Future<Database> get database async {
    // إذا كانت قاعدة البيانات موجودة بالفعل، أرجعها
    if (_database != null) return _database!;

    // إذا لم تكن موجودة، قم بتهيئتها
    _database = await _initDB('rafiqi_university.db');
    return _database!;
  }

  // 2. تهيئة قاعدة البيانات (إنشاء الملف وتحديد المسار)
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // فتح قاعدة البيانات. إذا لم تكن موجودة، سيتم استدعاء onCreate
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // 3. دالة لإنشاء الجداول عند أول تشغيل للتطبيق
  Future _createDB(Database db, int version) async {
    // يجب تحديد أنواع البيانات بدقة (INTEGER, TEXT, REAL)
    // NOT NULL يعني أن الحقل لا يمكن أن يكون فارغاً
    
    await db.execute('''
      CREATE TABLE subjects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_name TEXT NOT NULL,
        subject_code TEXT,
        instructor_name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE lectures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id INTEGER NOT NULL,
        lecture_title TEXT NOT NULL,
        lecture_date TEXT NOT NULL,
        start_time TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE assignments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        due_date TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
      )
    ''');

    // ... يمكنك إضافة باقي أوامر CREATE TABLE هنا بنفس الطريقة
    // لجدول الامتحانات، تتبع المذاكرة، إلخ.
  }

  // --- 4. دوال CRUD لجدول المواد (Subjects) ---

  // C - Create: إضافة مادة جديدة
  Future<int> createSubject(Subject subject) async {
    final db = await instance.database;
    // `db.insert` تقوم بإدخال الـ Map في الجدول المحدد
    // وتُرجع الـ id الخاص بالصف الجديد
    return await db.insert('subjects', subject.toMap());
  }

  // R - Read: قراءة مادة معينة بواسطة الـ id
  Future<Subject?> getSubjectById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'subjects',
      columns: ['id', 'subject_name', 'subject_code', 'instructor_name'],
      where: 'id = ?', // '?' تمنع SQL Injection
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Subject.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // R - Read: قراءة كل المواد
  Future<List<Subject>> getAllSubjects() async {
    final db = await instance.database;
    final result = await db.query('subjects', orderBy: 'subject_name ASC');

    // تحويل قائمة الـ Maps إلى قائمة من الـ Subjects
    return result.map((json) => Subject.fromMap(json)).toList();
  }

  // U - Update: تحديث بيانات مادة
  Future<int> updateSubject(Subject subject) async {
    final db = await instance.database;
    return await db.update(
      'subjects',
      subject.toMap(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  // D - Delete: حذف مادة
  Future<int> deleteSubject(int id) async {
    final db = await instance.database;
    return await db.delete(
      'subjects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // --- يمكنك إضافة دوال CRUD لبقية الجداول هنا ---
  // مثال: Future<int> createLecture(Lecture lecture) async { ... }
  // مثال: Future<List<Assignment>> getAllAssignments() async { ... }


  // دالة لإغلاق قاعدة البيانات عند عدم الحاجة إليها
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
