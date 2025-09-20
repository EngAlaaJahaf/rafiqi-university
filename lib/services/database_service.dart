// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rafiqi_university_v1.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB, onConfigure: _onConfigure);
  }

  // تفعيل المفاتيح الخارجية (Foreign Keys)
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // دالة إنشاء جميع الجداول
  Future _createDB(Database db, int version) async {
    // استخدام Batch لتنفيذ كل الأوامر دفعة واحدة لتحسين الأداء
    final batch = db.batch();

    // --- الجداول المساعدة (Lookup Tables) ---
    batch.execute('''
      CREATE TABLE sem_departments (
        dept_id INTEGER PRIMARY KEY AUTOINCREMENT,
        dept_name TEXT NOT NULL UNIQUE,
        dept_code TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_levels (
        level_id INTEGER PRIMARY KEY AUTOINCREMENT,
        level_number INTEGER NOT NULL UNIQUE,
        level_name TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_semesters (
        sem_id INTEGER PRIMARY KEY AUTOINCREMENT,
        sem_name TEXT NOT NULL,
        sem_start_date TEXT NOT NULL,
        sem_end_date TEXT NOT NULL,
        sem_is_current INTEGER NOT NULL DEFAULT 0
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_subjects (
        subj_id INTEGER PRIMARY KEY AUTOINCREMENT,
        subj_name TEXT NOT NULL,
        subj_code TEXT NOT NULL UNIQUE,
        subj_credit_hours INTEGER
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_teachers (
        teach_id INTEGER PRIMARY KEY AUTOINCREMENT,
        teach_name TEXT NOT NULL,
        teach_email TEXT UNIQUE,
        teach_phone TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_time_slots (
        ts_id INTEGER PRIMARY KEY AUTOINCREMENT,
        ts_name TEXT NOT NULL,
        ts_start_time TEXT NOT NULL,
        ts_end_time TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_class (
        cl_id INTEGER PRIMARY KEY AUTOINCREMENT,
        cl_name TEXT NOT NULL UNIQUE
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_lect_type (
        lec_id INTEGER PRIMARY KEY AUTOINCREMENT,
        lec_name TEXT NOT NULL UNIQUE
      )
    ''');

    // --- الجداول الأساسية ---
    batch.execute('''
      CREATE TABLE sem_user (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'student',
        dept_id INTEGER,
        level_id INTEGER,
        FOREIGN KEY (dept_id) REFERENCES sem_departments (dept_id) ON DELETE SET NULL,
        FOREIGN KEY (level_id) REFERENCES sem_levels (level_id) ON DELETE SET NULL
      )
    ''');

    // ملاحظة: تم تبسيط جدول الخطة الدراسية والتسجيل لسهولة البدء
    batch.execute('''
      CREATE TABLE sem_enrollments (
        enrollment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        subj_id INTEGER NOT NULL,
        enroll_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'ACTIVE',
        FOREIGN KEY (user_id) REFERENCES sem_user (user_id) ON DELETE CASCADE,
        FOREIGN KEY (subj_id) REFERENCES sem_subjects (subj_id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_lectures (
        lect_id INTEGER PRIMARY KEY AUTOINCREMENT,
        subj_id INTEGER NOT NULL,
        teach_id INTEGER,
        lect_date TEXT NOT NULL,
        ts_id INTEGER,
        lect_type_id INTEGER,
        cl_id INTEGER,
        is_completed INTEGER NOT NULL DEFAULT 0,
        notes TEXT,
        FOREIGN KEY (subj_id) REFERENCES sem_subjects (subj_id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_assignments (
        assign_id INTEGER PRIMARY KEY AUTOINCREMENT,
        subj_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (subj_id) REFERENCES sem_subjects (subj_id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_exams (
        exam_id INTEGER PRIMARY KEY AUTOINCREMENT,
        subj_id INTEGER NOT NULL,
        exam_type_id INTEGER,
        exam_date TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (subj_id) REFERENCES sem_subjects (subj_id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE sem_notifications (
        notif_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        message TEXT NOT NULL,
        notif_date TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES sem_user (user_id) ON DELETE CASCADE
      )
    ''');

    // تنفيذ كل الأوامر
    await batch.commit(noResult: true);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
// lib/services/database_helper.dart