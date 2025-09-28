// lib/model/REST/lecture_rest.dart

class LectureRest {
  final int lectId;
  final int subjId;
  final DateTime lectDate; // ✨ 1. أضفنا حقل التاريخ
  // يمكنك إضافة أي حقول أخرى تحتاجها من الـ API هنا

  LectureRest({
    required this.lectId,
    required this.subjId,
    required this.lectDate, // ✨ 2. أضفناه إلى المُنشئ
  });

  factory LectureRest.fromJson(Map<String, dynamic> json) {
    return LectureRest(
      lectId: json['lect_id'],
      subjId: json['subj_id'],
      // ✨ 3. قمنا بتحويل النص القادم من الـ API إلى كائن DateTime
      lectDate: DateTime.parse(json['lect_date']), 
    );
  }
}
