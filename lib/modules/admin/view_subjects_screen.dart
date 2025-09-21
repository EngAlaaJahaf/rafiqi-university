import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. استيراد Provider
import 'package:rafiqi_university/layout/fab_view_model.dart'; // 2. استيراد الـ ViewModel
import 'package:rafiqi_university/model/repository/subjects_repository.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/modules/room_classes/lectures_screen.dart';
// تأكد من وجود دالة showSubjectDialog في مكان ما يمكن الوصول إليه
// import 'package:rafiqi_university/shared/dialogs/subject_dialog.dart';

class ViewSubjectsScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const ViewSubjectsScreen({super.key, required this.toggleTheme});

  @override
  State<ViewSubjectsScreen> createState() => _ViewSubjectsScreenState();
}

class _ViewSubjectsScreenState extends State<ViewSubjectsScreen> {
  late Future<List<Subject>> _subjects;

  @override
  void initState() {
    super.initState();
    _refreshSubjects();

    // 3. استخدم addPostFrameCallback لضمان أن الـ build قد اكتمل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 4. اقرأ الـ ViewModel وقم بتعيين وظيفة الزر العائم الخاصة بهذه الشاشة
      Provider.of<FabViewModel>(context, listen: false).setFabAction(_openAddDialog);
    });
  }

  @override
  void dispose() {
    // 5. (مهم جدًا) قم بإزالة وظيفة الزر عند مغادرة الشاشة
    // هذا يضمن عدم ظهور الزر في الشاشة التالية عن طريق الخطأ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
      }
    });
    super.dispose();
  }

  void _refreshSubjects() {
    setState(() {
      _subjects = SubjectsRepository.instance.getAll();
    });
  }

  // هذه هي الوظيفة التي سيتم استدعاؤها بواسطة الزر العائم
  void _openAddDialog({Subject? subject}) async {
    // افترض أن showSubjectDialog هي دالة عامة الآن
    final result = await showSubjectDialog(context, subject: subject);
    if (result == true) {
      _refreshSubjects();
    }
    print('تم الضغط على الزر العائم في شاشة المواد!');
  }

  @override
  Widget build(BuildContext context) {
    // 6. لا يوجد Scaffold هنا، فقط محتوى الشاشة
    return FutureBuilder<List<Subject>>(
      future: _subjects,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد مواد مسجلة.'));
        }

        final subjects = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('الرمز: ${subject.code ?? 'N/A'}\nعدد الساعات: ${subject.creditHours ?? 'N/A'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      IconButton(
                      icon: const Icon(Icons.edit, color: Color.fromARGB(255, 27, 176, 239)),
                      onPressed: () => _openAddDialog(subject: subject),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('تأكيد الحذف'),
                            content: const Text('هل أنت متأكد من حذف هذه المادة ؟'),
                            actions: [
                              
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('إلغاء'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('حذف', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true ) {
                          await SubjectsRepository.instance.delete(subject.id!);
                          _refreshSubjects();
                        };
                      },
                    ),
                  
                  ],
                ),
                // onTap: () => _openAddDialog(subject: subject),
              ),
            );
          },
        );
      },
    );
  }
}
