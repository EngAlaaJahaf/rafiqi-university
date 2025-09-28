// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rafiqi_university/model/REST/assignment_rest.dart';
import 'package:rafiqi_university/model/REST/lecture_rest.dart';
import 'package:rafiqi_university/model/REST/notification_rest.dart';
import 'package:rafiqi_university/model/REST/subject_rest.dart';

class ApiService {
  final String _baseUrl = "https://oracleapex.com/ords/oracledb1/";

  // ✨ --- الروابط المصححة والنهائية --- ✨
  // تم توحيد كل الروابط لتتبع نفس النمط الناجح (بدون "/" في النهاية )
  final String _assignmentsUrl = "sem_assignments/assingment/:id";
  final String _assignmentPostUrl = "sem_assignments/assignment_post/";
  final String _lecturesUrl = "sem_lectures/lectures"; // ✅ تم التصحيح
  final String _notificationsUrl = "sem_notifications/notifications"; // ✅ تم التصحيah
  final String _subjectsUrl = "sem_subjects/subjects"; // ✅ تم التصحيح

  // --- دوال جلب البيانات (GET) ---
  
  Future<List<SubjectRest>> getSubjects() async {
    final response = await http.get(Uri.parse('$_baseUrl$_subjectsUrl' ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['items'] as List;
      return data.map((item) => SubjectRest.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load subjects. Status: ${response.statusCode}');
    }
  }

  Future<List<AssignmentRest>> getAssignments() async {
    final response = await http.get(Uri.parse('$_baseUrl$_assignmentsUrl' ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['items'] as List;
      return data.map((item) => AssignmentRest.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load assignments. Status: ${response.statusCode}');
    }
  }

  Future<List<LectureRest>> getLectures() async {
    final response = await http.get(Uri.parse('$_baseUrl$_lecturesUrl' ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['items'] as List;
      return data.map((item) => LectureRest.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load lectures. Status: ${response.statusCode}');
    }
  }

  Future<List<NotificationRest>> getNotifications() async {
    final response = await http.get(Uri.parse('$_baseUrl$_notificationsUrl' ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['items'] as List;
      return data.map((item) => NotificationRest.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifications. Status: ${response.statusCode}');
    }
  }

  // --- دوال إدارة التكاليف (CRUD) ---
  // (باقي الدوال تبقى كما هي تماماً لأنها تستخدم روابط مختلفة أو تبني الـ URL بشكل مختلف)

  Future<void> addAssignment(AssignmentRest assignment) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_assignmentPostUrl' ),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'assign_title': assignment.assignTitle,
        'assign_desc': assignment.assignDescription ?? '',
        'assign_due_date': DateFormat('yyyy-MM-dd').format(assignment.assignDueDate),
        'lect_id': assignment.lectId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add assignment. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> updateAssignment(AssignmentRest assignment) async {
    // هذا الرابط يبني نفسه بشكل مختلف، لذلك هو صحيح
    final url = '$_baseUrl${_assignmentsUrl.split(':')[0]}${assignment.assignId}';
    final response = await http.put(
      Uri.parse(url ),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'assign_title': assignment.assignTitle,
        'assign_desc': assignment.assignDescription ?? '',
        'assign_due_date': DateFormat('yyyy-MM-dd').format(assignment.assignDueDate),
        'lect_id': assignment.lectId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update assignment. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> deleteAssignment(int assignmentId) async {
    final url = '$_baseUrl${_assignmentsUrl.split(':')[0]}$assignmentId';
    final response = await http.delete(Uri.parse(url ));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete assignment. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    final url = '$_baseUrl$_notificationsUrl/$notificationId'; // هذا الرابط قد يحتاج مراجعة لاحقاً
    final response = await http.delete(Uri.parse(url ));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete notification. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
