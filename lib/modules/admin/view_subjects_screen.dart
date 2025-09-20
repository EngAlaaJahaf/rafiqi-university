import 'package:flutter/material.dart';
import 'package:rafiqi_university/model/repository/subjects_repository.dart';
import 'package:rafiqi_university/model/subject.dart';
import 'package:rafiqi_university/modules/room_classes/lectures_screen.dart';
// import 'package:rafiqi_university/services/database_service.dart';

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
      _subjects = SubjectsRepository.instance.getAll();
    });
  }

  void showAddSubjectDialog({Subject? subject}) async {
    final result = await showSubjectDialog(context, subject: subject);

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
                  title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('الرمز: ${subject.code ?? 'N/A'}\nعدد الساعات: ${subject.creditHours ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await SubjectsRepository.instance.delete(subject.id!);
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
        shape: const CircleBorder(),
        onPressed: () => showAddSubjectDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
