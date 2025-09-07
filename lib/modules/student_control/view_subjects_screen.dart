import 'package:flutter/material.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/modules/student_control/add_subject.dart';
import 'package:rafiqi_university/services/database_helper.dart';

class ViewSubjectsScreen extends StatefulWidget {
  const ViewSubjectsScreen({super.key, required VoidCallback toggleTheme});

  @override
  State<ViewSubjectsScreen> createState() => _ViewSubjectsScreenState();
}

class _ViewSubjectsScreenState extends State<ViewSubjectsScreen> {
  late Future<List<Subject>> _subjects;

  @override
  void initState() {
    super.initState();
    _refreshSubjects();
  }

  void _refreshSubjects() {
    setState(() {
      _subjects = DatabaseHelper.instance.getAllSubjects();
    });
  }

  void showAddSubjectDialog({Subject? subject}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddSubjectDialog(subject: subject),
    );

    if (result == true) {
      _refreshSubjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: FutureBuilder<List<Subject>>(
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
                  title: Text(subject.subject_name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('الرمز: ${subject.subject_code ?? 'N/A'}\nالمدرس: ${subject.instructor_name ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await DatabaseHelper.instance.deleteSubject(subject.id!);
                      _refreshSubjects();
                    },
                  ),
                  onTap: () => showAddSubjectDialog(subject: subject),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddSubjectDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
