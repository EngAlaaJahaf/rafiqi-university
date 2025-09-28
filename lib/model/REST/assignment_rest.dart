// lib/model/REST/assignment_model.dart

import 'dart:convert';

// دالة مساعدة لتحويل قائمة من الكائنات إلى JSON
String assignmentListToJson(List<AssignmentRest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AssignmentRest {
  final int assignId;
  final int lectId;
  final String assignTitle;
  final String? assignDescription; // يمكن أن يكون null
  final DateTime assignDueDate;
  final bool isCompleted; // استخدام bool بدلاً من 'Y'/'N' لسهولة التعامل في Dart

  AssignmentRest({
    required this.assignId,
    required this.lectId,
    required this.assignTitle,
    this.assignDescription,
    required this.assignDueDate,
    required this.isCompleted, required assignIsCompleted,
  });

  // دالة Factory لتحويل JSON القادم من API إلى كائن Assignment
  factory AssignmentRest.fromJson(Map<String, dynamic> json) {
    return AssignmentRest(
      // Oracle APEX عادة ما يرسل أسماء الحقول بأحرف صغيرة (lowercase)
      assignId: json["assign_id"],
      lectId: json["lect_id"],
      assignTitle: json["assign_title"],
      assignDescription: json["assign_description"],
      assignDueDate: DateTime.parse(json["assign_due_date"]),
      // تحويل 'Y' إلى true، وأي شيء آخر إلى false
      isCompleted: json["assign_is_completed"] == 'Y', assignIsCompleted: null,
    );
  }

  // دالة لتحويل كائن Assignment إلى JSON لإرساله إلى الـ API
  Map<String, dynamic> toJson() {
    return {
      // لا نرسل الـ ID عند الإنشاء، ولكن قد نحتاجه عند التحديث
      // "assign_id": assignId, 
      "lect_id": lectId,
      "assign_title": assignTitle,
      "assign_description": assignDescription,
      // تحويل التاريخ إلى الصيغة التي يفهمها Oracle (YYYY-MM-DD)
      "assign_due_date": assignDueDate.toIso8601String().split('T').first,
      // تحويل bool إلى 'Y' أو 'N'
      "assign_is_completed": isCompleted ? 'Y' : 'N',
    };
  }
}
