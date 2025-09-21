import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/model/department.dart';
import 'package:rafiqi_university/model/level.dart';
import 'package:rafiqi_university/model/repository/departments_repository.dart';
import 'package:rafiqi_university/model/repository/levels_repository.dart';
import 'package:rafiqi_university/model/repository/users_repository.dart';
import 'package:rafiqi_university/model/user.dart';
import 'package:rafiqi_university/shared/components/dialog_helpers.dart';
import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';
import 'package:rafiqi_university/shared/components/reusable_list_item.dart';

class AddUserPage extends StatefulWidget {
  // لم نعد بحاجة لـ toggleTheme هنا
  const AddUserPage({super.key, required VoidCallback toggleTheme});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  // ✨ 1. Futures منفصلة لكل نوع من البيانات
  late Future<List<User>> _usersFuture;
  late Future<List<Department>> _departmentsFuture;
  late Future<List<Level>> _levelsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();

    // ✨ 2. تعيين وظيفة الزر العائم في initState
    // ستستدعي دالة _openAddDialog التي ستقوم بجلب البيانات المطلوبة بنفسها
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FabViewModel>(context, listen: false).setFabAction(_openAddDialog);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
      }
    });
    super.dispose();
  }

  // ✨ 3. دالة واحدة لتحديث كل البيانات
  void _refreshData() {
    setState(() {
      _usersFuture = UsersRepository.instance.getAll();
      _departmentsFuture = DepartmentsRepository.instance.getAll();
      _levelsFuture = LevelsRepository.instance.getAll();
    });
  }

  // ✨ 4. دالة فتح نافذة الإضافة، الآن أكثر ذكاءً
  void _openAddDialog({User? user}) async {
    // جلب بيانات القوائم المنسدلة **فقط** عند الحاجة إليها
    final departments = await _departmentsFuture;
    final levels = await _levelsFuture;

    final departmentOptions = departments
        .map((d) => DropdownOption(label: d.name, value: d.id.toString()))
        .toList();
    final levelOptions = levels
        .map((l) => DropdownOption(label: l.name, value: l.id.toString()))
        .toList();

    final fields = [
      // ... (حقول النموذج كما هي)
      FormFieldConfig(
        name: 'user_name',
        label: 'اسم المستخدم',
        initialValue: user?.username,
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال اسم المستخدم' : null, keyboardType: TextInputType.text,
      ),
      FormFieldConfig(
        name: 'user_email',
        label: 'البريد الإلكتروني',
        initialValue: user?.email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
          if (!emailRegex.hasMatch(value)) return 'بريد إلكتروني غير صالح';
          return null;
        },
      ),
      FormFieldConfig(
        name: 'user_password',
        label: 'كلمة المرور',
        validator: (value) => (user == null && (value == null || value.isEmpty)) ? 'الرجاء إدخال كلمة المرور' : null,
        // obscureText: true,
         keyboardType: TextInputType.text,
      ),
      FormFieldConfig(
        name: 'full_name',
        label: 'الاسم الكامل',
        initialValue: user?.fullName,
        keyboardType: TextInputType.text,
        validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال الاسم الكامل' : null,
      ),
      FormFieldConfig(
        name: 'role',
        label: 'الدور',
        type: FormFieldType.dropdown,
        keyboardType: TextInputType.text,
        initialValue: user?.role ?? 'student',
        dropdownOptions:  [
          DropdownOption(label: 'طالب', value: 'student'),
          DropdownOption(label: 'مندوب', value: 'delegate'),
          DropdownOption(label: 'مسؤول', value: 'admin'),
        ],
      ),
      FormFieldConfig(
        name: 'dept_id',
        label: 'القسم',
        type: FormFieldType.dropdown,
        keyboardType: TextInputType.text,
        dropdownOptions: departmentOptions,
        initialValue: user?.deptId?.toString(),
        validator: (value) => (value == null) ? 'الرجاء اختيار القسم' : null,
      ),
      FormFieldConfig(
        name: 'level_id',
        label: 'المستوى',
        keyboardType: TextInputType.text,
        type: FormFieldType.dropdown,
        dropdownOptions: levelOptions,
        initialValue: user?.levelId?.toString(),
        validator: (value) => (value == null) ? 'الرجاء اختيار المستوى' : null,
      ),
    ];

    Future<void> onSave(Map<String, dynamic> data) async {
      final newUser = User(
        id: user?.id,
        username: data['user_name'] as String,
        email: data['user_email'] as String,
        passwordHash: (data['user_password'] != null && (data['user_password'] as String).isNotEmpty)
            ? data['user_password'] as String
            : user?.passwordHash ?? '',
        fullName: data['full_name'] as String,
        role: data['role'] as String,
        deptId: int.tryParse(data['dept_id'] as String),
        levelId: int.tryParse(data['level_id'] as String),
      );

      if (user == null) {
        await UsersRepository.instance.create(newUser);
      } else {
        await UsersRepository.instance.update(newUser);
      }
      _refreshData();
    }

    showDialog(
      context: context,
      builder: (context) => ReusableFormDialog(
        title: user == null ? 'إضافة مستخدم جديد' : 'تعديل المستخدم',
        fields: fields,
        onSave: onSave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✨ 5. استخدام FutureBuilder لعرض قائمة المستخدمين
    return FutureBuilder<List<User>>(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا يوجد مستخدمون. اضغط على زر + للإضافة.'));
        }

        final users = snapshot.data!;

        // ✨ 6. استخدام FutureBuilder متداخل لجلب بيانات القوائم المنسدلة
        // هذا يضمن أننا لا نعيد بناء قائمة المستخدمين في كل مرة
        return FutureBuilder(
          future: Future.wait([_departmentsFuture, _levelsFuture]),
          builder: (context, relatedDataSnapshot) {
            if (relatedDataSnapshot.connectionState == ConnectionState.waiting) {
              // أظهر القائمة القديمة أثناء تحميل البيانات الجديدة (تجربة مستخدم أفضل)
              return _buildUserListView(users, [], []);
            }

            final departments = (relatedDataSnapshot.data?[0] as List<Department>?) ?? [];
            final levels = (relatedDataSnapshot.data?[1] as List<Level>?) ?? [];

            return _buildUserListView(users, departments, levels);
          },
        );
      },
    );
  }

  // ✨ 7. فصل منطق بناء القائمة في دالة منفصلة
  Widget _buildUserListView(List<User> users, List<Department> departments, List<Level> levels) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final deptName = departments.firstWhere((d) => d.id == user.deptId, orElse: () => Department(id: 0, name: 'N/A')).name;
        final levelName = levels.firstWhere((l) => l.id == user.levelId, orElse: () => Level(id: 0, name: 'N/A', number: 0)).name;

        return ReusableListItem(
          title: user.fullName,
          subtitle: 'القسم: $deptName | المستوى: $levelName',
          leadingIcon: Icons.person_outline,
          onEdit: () => _openAddDialog(user: user),
          onDelete: () async {
            final confirm = await showDeleteConfirmationDialog(context, itemName: user.fullName);
            if (confirm) {
              await UsersRepository.instance.delete(user.id!);
              _refreshData();
            }
          },
        );
      },
    );
  }
}
