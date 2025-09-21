import 'package:flutter/material.dart';
import 'package:rafiqi_university/modules/admin/add_class_room_page.dart';
import 'package:rafiqi_university/modules/admin/add_department_page.dart';
import 'package:rafiqi_university/modules/admin/add_enrollment_page.dart';
import 'package:rafiqi_university/modules/admin/add_lecture_type_page.dart';
import 'package:rafiqi_university/modules/admin/add_level_page.dart';
import 'package:rafiqi_university/modules/admin/add_notification_page.dart';
import 'package:rafiqi_university/modules/admin/add_semester_page.dart';
import 'package:rafiqi_university/modules/admin/add_teacher_page.dart';
import 'package:rafiqi_university/modules/admin/add_user_page.dart';
import 'package:rafiqi_university/modules/admin/view_subjects_screen.dart';
import 'package:rafiqi_university/shared/components/admin_dashboard_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  // ✨ 1. استقبل دالة onSecondaryNavigate من MainLayoutWidget
  final Function(Widget, String) onSecondaryNavigate;
  final VoidCallback toggleTheme;

  const AdminDashboardScreen({
    super.key,
    required this.onSecondaryNavigate,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16.0),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.1,
      children: [
        AdminDashboardCard(
          title: 'القاعات',
          emoji: '🏫',
          // ✨ 2. (الحل) استخدم onSecondaryNavigate لتغيير المحتوى
          onTap: () => onSecondaryNavigate(
            AddClassRoomPage(toggleTheme: toggleTheme), // الـ Widget الذي سيتم عرضه
            'إدارة القاعات', // العنوان الجديد للـ AppBar
          ),
        ),
        AdminDashboardCard(
          title: 'المدرسين',
          emoji: '👨‍🏫',
          onTap: () => onSecondaryNavigate(
            AddTeacherPage(toggleTheme: toggleTheme),
            'إدارة المدرسين',
          ),
        ),
        AdminDashboardCard(
          title: 'التخصصات',
          emoji: '🎓',
          onTap: () => onSecondaryNavigate(
            AddDepartmentPage(toggleTheme: toggleTheme),
            'إدارة التخصصات',
          ),
        ),
        AdminDashboardCard(
          title: 'المواد',
          emoji: '📚',
          onTap: () => onSecondaryNavigate(
            ViewSubjectsScreen(toggleTheme: toggleTheme),
            'إدارة المواد',
          ),
        ),
        AdminDashboardCard(
          title: 'الطلاب',
          emoji: '👥',
          onTap: () => onSecondaryNavigate(
            // ملاحظة: صفحة إضافة المستخدم التي أنشأناها لا تحتاج لـ toggleTheme
             AddUserPage(toggleTheme: toggleTheme),
            'إدارة الطلاب',
          ),
        ),
        AdminDashboardCard(
          title: 'الفصول',
          emoji: '🗓️',
          onTap: () => onSecondaryNavigate(
            AddSemesterPage(toggleTheme: toggleTheme),
            'إدارة الفصول',
          ),
        ),
        AdminDashboardCard(
          title: 'المستويات',
          emoji: '📶',
          onTap: () => onSecondaryNavigate(
            AddLevelPage(toggleTheme: toggleTheme),
            'إدارة المستويات',
          ),
        ),
        AdminDashboardCard(
          title: 'نوع المحاضرة',
          emoji: '📶',
          onTap: () => onSecondaryNavigate(
            AddEnrollmentPage(toggleTheme: toggleTheme),
            'إدارة نوع المحاضرة',
          ),
        ),
        AdminDashboardCard(
          title: 'الفترات الزمنية',
          emoji: '⏰',
          onTap: () => onSecondaryNavigate(
            AddLectureTypePage(toggleTheme: toggleTheme),
            'إدارة الفترات الزمنية',
          ),
        ),
        AdminDashboardCard(
          title: 'تسجيل المواد ',
          emoji: '📕📗📘',
          onTap: () => onSecondaryNavigate(
            AddLectureTypePage(toggleTheme: toggleTheme),
            'إدارة تسجيل المواد',
          ),
        ),
        AdminDashboardCard(
          title: 'الإشعارات',
          emoji: '🔔',
          onTap: () => onSecondaryNavigate(
            NotificationsPage(toggleTheme: toggleTheme),
            'إدارة  الإشعارات',
          ),
        ),
        // ... يمكنك إضافة المزيد من البطاقات هنا
      ],
    );
  }
}
