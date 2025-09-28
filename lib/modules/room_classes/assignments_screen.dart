// lib/modules/assignments/assignments_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiqi_university/layout/fab_view_model.dart';
import 'package:rafiqi_university/model/REST/add_edit_assignment_screen.dart';
import 'package:rafiqi_university/model/REST/assignment_rest.dart';
import 'package:rafiqi_university/services/api_service.dart';
import 'package:intl/intl.dart';
// import 'add_edit_assignment_screen.dart'; // ✨ 1. قم باستيراد الشاشة الجديدة

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key, required VoidCallback toggleTheme});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  late Future<List<AssignmentRest>> _assignmentsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadAssignments();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FabViewModel>(context, listen: false).setFabAction(() {
        _navigateToAddEditScreen(); // ✨ 2. تفعيل استدعاء الدالة
      });
    });
  }

  void _loadAssignments() {
    setState(() {
      _assignmentsFuture = _apiService.getAssignments();
    });
  }

  // ✨ 3. دالة الانتقال لشاشة الإضافة أو التعديل
  Future<void> _navigateToAddEditScreen({AssignmentRest? assignment}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddEditAssignmentScreen(
          assignment: assignment,
          onSave: () {
            _loadAssignments();
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );

    // إذا رجعنا بنتيجة "true"، فهذا يعني أن الحفظ نجح، لذا نُعيد تحميل القائمة
    if (result == true) {
      _loadAssignments();
    }
  }

  // ✨ 4. دالة الحذف
  Future<void> _deleteAssignment(int id) async {
    // عرض نافذة تأكيد قبل الحذف
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من رغبتك في حذف هذا التكليف؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('حذف')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _apiService.deleteAssignment(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم الحذف بنجاح'), backgroundColor: Colors.green),
        );
        _loadAssignments(); // إعادة تحميل القائمة بعد الحذف
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في الحذف: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator( // ✨ 5. إضافة إمكانية السحب للتحديث
        onRefresh: () async => _loadAssignments(),
        child: FutureBuilder<List<AssignmentRest>>(
          future: _assignmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('لا توجد تكاليف حالياً.'));
            }

            final assignments = snapshot.data!;
            return ListView.builder(
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(assignment.assignTitle),
                    subtitle: Text('تاريخ التسليم: ${DateFormat('yyyy-MM-dd').format(assignment.assignDueDate.toLocal())}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _navigateToAddEditScreen(assignment: assignment); // ✨ 6. تفعيل زر التعديل
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteAssignment(assignment.assignId); // ✨ 7. تفعيل زر الحذف
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
