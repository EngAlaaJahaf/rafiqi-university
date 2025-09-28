// lib/model/REST/subject_rest.dart

class SubjectRest {
  final int subjId;
  final String subjName;

  SubjectRest({
    required this.subjId,
    required this.subjName,
  });

  factory SubjectRest.fromJson(Map<String, dynamic> json) {
    return SubjectRest(
      subjId: json['subj_id'],
      subjName: json['subj_name'],
    );
  }
}
