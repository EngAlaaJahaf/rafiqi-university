// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rafiqi_university/layout/fab_view_model.dart';
// import 'package:rafiqi_university/model/enrollment.dart';
// import 'package:rafiqi_university/model/repository/enrollment_repository.dart';
// import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';

// class AddEnrollmentPage extends StatefulWidget {
//   const AddEnrollmentPage({super.key});

//   @override
//   State<AddEnrollmentPage> createState() => _AddEnrollmentPageState();
// }

// class _AddEnrollmentPageState extends State<AddEnrollmentPage> {
//   final EnrollmentRepository _enrollmentRepo = EnrollmentRepository.instance;
//   late Future<List<Enrollment>> _enrollmentsFuture;

// @override  void initState() {
//     super.initState();
//      _refreshEnrollments();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // 4. اقرأ الـ ViewModel وقم بتعيين وظيفة الزر العائم الخاصة بهذه الشاشة
//       Provider.of<FabViewModel>(context, listen: false).setFabAction(_openAddDialog);
//     });
// }

// @override
//   void dispose() {
//     // 5. (مهم جدًا) قم بإزالة وظيفة الزر عند مغادرة الشاشة
//     // هذا يضمن عدم ظهور الزر في الشاشة التالية عن طريق الخطأ
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         Provider.of<FabViewModel>(context, listen: false).setFabAction(null);
//       }
//     });
//     super.dispose();
//   }
// Future<void> _refreshEnrollments() async {
//     setState(() {
//       _enrollmentsFuture = EnrollmentRepository.instance.getAll();
//     });
//   }
// void _openAddDialog({Enrollment? enrollment}) async {
//     DateTime? enrollmentDate = enrollment?.enrollmentDate;
//     // final String? formattedDate = enrollmentDate != null
//     //     ? "${enrollmentDate.year}-${enrollmentDate.month.toString().padLeft(2, '0')}-${enrollmentDate.day.toString().padLeft(2, '0')}"
//     //     : null;
//     // جلب جميع المستويات مسبقًا للتحقق من التكرار
//     // final List<Enrollment> existingEnrollments = await _enrollmentRepo.getAll();
//     final String? formattedDate = enrollmentDate != null
//         ? "${enrollmentDate.year}-${enrollmentDate.month.toString().padLeft(2, '0')}-${enrollmentDate.day.toString().padLeft(2, '0')}"
//         : null;
//     // جلب جميع المستويات مسبقًا للتحقق من التكرار
//     final List<Enrollment> existingEnrollments = await _enrollmentRepo.getAll();
    
//     final fields = [
//       // FormFieldConfig(
//       //   name: 'enroll_name',
//       //   label: 'اسم التسجيل',
//       //   initialValue: enrollment?.name, // دعم التعديل
//       //   keyboardType: TextInputType.text,
//       //   validator: (value) {
//       //     if (value == null || value.isEmpty) {
//       //       return 'الرجاء إدخال اسم التسجيل';
//       //     }
//       //     // تحقق من التكرار
//       //     if (existingEnrollments.any((e) => e.name == value && e.id != enrollment?.id)) {
//       //       return 'اسم التسجيل مستخدم بالفعل';
//       //     }
//       //     return null;
//       //   },
//       // ),
//       FormFieldConfig(
//         name: 'student_id',
//         label: 'الطالب ',
//         initialValue: enrollment?.usertId != null ? enrollment! .id.toString() : null, // دعم التعديل
//         keyboardType: TextInputType.text,
//         validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال وصف التسجيل' : null,
//       ),
//       FormFieldConfig(
//         name: 'course_id',
//         label: 'المادة ',
//         initialValue: enrollment?.courseId != null ? enrollment! .id.toString() : null, // دعم التعديل
//         keyboardType: TextInputType.text,
//         validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال وصف التسجيل' : null,
//       ),
//       FormFieldConfig(
//         name: 'enroll_date',
//         label: 'تاريخ التسجيل',
//         type: FormFieldType.date,
//         initialValue: enrollmentDate != null
//             ? "${enrollment!.enrollmentDate.year}-${enrollment.enrollmentDate.month.toString().padLeft(2, '0')}-${enrollment.enrollmentDate.day.toString().padLeft(2, '0')}"
//             : null  ,
//         validator: (value) => (value == null || value.isEmpty) ? 'الرجاء اختيار تاريخ البداية' : null,
//         keyboardType: TextInputType.datetime,
//       ),
//     ];

//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) => ReusableFormDialog(
//         title: enrollment == null ? 'إضافة تسجيل جديد' : 'تعديل التسجيل',
//         fields: fields,
//         onSubmit: (formData) async {
//           final newEnrollment = Enrollment(
//             id: enrollment?.id,
//             name: formData['enroll_name'],
//             description: formData['enroll_description'],
//           );
//           if (enrollment == null) {
//             await _enrollmentRepo.insert(newEnrollment);
//           } else {
//             await _enrollmentRepo.update(newEnrollment);
//           }
//           Navigator.of(context).pop(true); // إشارة إلى النجاح
//         }, onSave: (Map<String, dynamic> data) {  },
//       ),
//     );

//     if (result == true) {
//       _refreshEnrollments();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }