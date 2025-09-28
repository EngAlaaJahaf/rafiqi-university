// lib/model/view_models/lecture_view_model.dart

import 'package:intl/intl.dart';

class LectureViewRest {
  final int lectId;
  final String displayText;

  LectureViewRest({
    required this.lectId,
    required this.displayText,
  });

  // دالة لإنشاء نص وصفي من اسم المادة وتاريخ المحاضرة
  static String createDisplayText(String subjectName, DateTime lectureDate) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(lectureDate);
    return '$subjectName - $formattedDate';
  }
}
