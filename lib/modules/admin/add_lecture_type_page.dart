// import 'package:flutter/material.dart';
// import 'package:rafiqi_university/model/lect_type.dart';
// import 'package:rafiqi_university/model/repository/lecture_type_repository%20.dart';
// import 'package:rafiqi_university/shared/components/reusable_form_dialog.dart';

// class AddLectureTypePage extends StatefulWidget {
//   const AddLectureTypePage({super.key, required VoidCallback toggleTheme});

//   @override
//   State<AddLectureTypePage> createState() => _AddLectureTypePageState();
// }

// class _AddLectureTypePageState extends State<AddLectureTypePage> {

//   final LectureTypeRepository _lecturesTypeRepo = LectureTypeRepository.instance;
  
//   late Future<List<LectType>> _lecturesFuture;
  
//   @override
//   void initState(){
//     super.initState();
    
//   }
  
//   void _showAddLectureTypeDialog(List<LectType> lectureTypes) {
//     final fields = [
//       FormFieldConfig(
//         name: 'lect_type_name',
//         label: 'نوع المحاضرة',
//         type: FormFieldType.text,
//         validator: (value) => (value == null || value.isEmpty) ? 'الرجاء إدخال نوع المحاضرة' : null,
//       ),
     
//     ];

//     Future<void> onSave(Map<String, dynamic> data) async {
//       final newLectType = LectType(
//         id: data['lect_type_id'],
//         name: data['lect_type_name'],
        
//       );

//       await _lecturesTypeRepo.create(newLectType);
//       setState(() {
//         _lecturesFuture = LectureTypeRepository.instance.getAll();
//       });
//     }

//     showDialog(
//       context: context,
//       builder: (context) => ReusableFormDialog(
//         title: 'إضافة نوع محاضرة جديد',
//         fields: fields,
//         onSave: onSave,
//       ),
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         title: const Text('إدارة أنواع المحاضرات'),
//       ),
//       body: FutureBuilder<List<LectType>>(
//         future: _lecturesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('حدث خطأ: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('لا توجد أنواع محاضرات.'));
//           } else {
//             final lectureTypes = snapshot.data!;
//             return ListView.builder(
//               itemCount: lectureTypes.length,
//               itemBuilder: (context, index) {
//                 final lectType = lectureTypes[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   child: ListTile(
//                     title: Text(lectType.name, style: const TextStyle(fontWeight: FontWeight.bold)),
//                     trailing: IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () async {
//                       await LectureTypeRepository.instance.delete(lectType.id!);
//                       _refreshSubjects();
//                     },
//                   ),
//                   onTap: () => showAddSubjectTypeDialog(subject: lectType),
//                 ),
//               );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddLectureTypeDialog([]),
//         child: const Icon(Icons.add),
//         tooltip: 'إضافة نوع محاضرة',
//       ),
//     );
//   }
// }