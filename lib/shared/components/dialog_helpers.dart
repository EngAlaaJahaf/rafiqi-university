import 'package:flutter/material.dart';

// ✨ هذه هي الدالة المساعدة التي سنستخدمها في كل مكان
Future<bool> showDeleteConfirmationDialog(
  BuildContext context, {
  required String itemName, // اسم العنصر الذي سيتم حذفه
}) async {
  // showDialog تُرجع القيمة التي يتم تمريرها إلى Navigator.pop()
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف "$itemName"؟'),
        actions: <Widget>[
          TextButton(
            // عند الضغط على "إلغاء"، أغلق النافذة وأرجع false
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            // عند الضغط على "حذف"، أغلق النافذة وأرجع true
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'حذف',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      );
    },
  );

  // إذا أغلق المستخدم النافذة بالضغط خارجها، ستكون النتيجة null
  // لذلك، نرجع false في هذه الحالة لضمان عدم الحذف
  return result ?? false;
}

// onDelete: () async {
//     await _levelsRepo.delete(level.id!);
//     _refreshLevels();
//   },

//--------------