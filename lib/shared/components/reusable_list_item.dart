// import 'package:flutter/material.dart';

// // ✨ هذا هو الـ Widget النهائي والمصقول بالكامل
// class ReusableListItem extends StatelessWidget {
//   // --- المعلمات الأساسية ---
//   final String title;
//   final String? subtitle;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   // --- معلمات التحسينات الإضافية ---
//   final IconData? leadingIcon; // 1. أيقونة اختيارية تظهر في البداية
//   final Color? leadingIconColor; // لون مخصص للأيقونة
//   final VoidCallback? onTap; // وظيفة اختيارية عند الضغط على العنصر

//   const ReusableListItem({
//     super.key,
//     required this.title,
//     this.subtitle,
//     required this.onEdit,
//     required this.onDelete,
//     this.leadingIcon,
//     this.leadingIconColor,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       elevation: 2.0,
//       // 2. استخدام ClipRRect لضمان أن تأثير الضغط (InkWell) يتبع حواف البطاقة
//       clipBehavior: Clip.antiAlias, 
//       child: InkWell(
//         // 3. تحديد وظيفة الضغط وتأثير المرور
//         onTap: onTap ?? onEdit, // إذا لم يتم تحديد onTap، استخدم onEdit
//         hoverColor: theme.primaryColor.withOpacity(0.05), // تأثير عند مرور الفأرة
//         splashColor: theme.primaryColor.withOpacity(0.1), // تأثير عند الضغط
//         highlightColor: theme.primaryColor.withOpacity(0.1),

//         child: ListTile(
//           // 4. (تحسين) إضافة أيقونة رئيسية أنيقة داخل دائرة
//           leading: leadingIcon != null
//               ? CircleAvatar(
//                   backgroundColor: (leadingIconColor ?? theme.colorScheme.primary).withOpacity(0.1),
//                   child: Icon(
//                     leadingIcon,
//                     color: leadingIconColor ?? theme.colorScheme.primary,
//                     size: 22,
//                   ),
//                 )
//               : null,

//           // 5. (تحسين) استخدام أنماط نصوص من الـ Theme لضمان الاتساق
//           title: Text(
//             title,
//             style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           subtitle: subtitle != null
//               ? Text(
//                   subtitle!,
//                   style: theme.textTheme.bodySmall,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 )
//               : null,

//           // 6. بناء أزرار الإجراءات (التعديل والحذف)
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.edit_outlined),
//                 color: theme.colorScheme.primary,
//                 tooltip: 'تعديل',
//                 onPressed: onEdit,
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete_outline),
//                 color: theme.colorScheme.error,
//                 tooltip: 'حذف',
//                 onPressed: onDelete,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart'; // ✨ 1. استيراد الحزمة

// class ReusableListItem extends StatelessWidget {
//   // ... (المعلمات كما هي)
//   final String title;
//   final String? subtitle;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final IconData? leadingIcon;
//   final Color? leadingIconColor;
//   final VoidCallback? onTap;

//   const ReusableListItem({
//     super.key,
//     required this.title,
//     this.subtitle,
//     required this.onEdit,
//     required this.onDelete,
//     this.leadingIcon,
//     this.leadingIconColor,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     // ✨ 2. لف كل شيء داخل Slidable Widget
//     return Slidable(
//       // --- تحديد الإجراءات التي تظهر عند السحب ---
//       key: ValueKey(title), // مفتاح فريد لكل عنصر
//       endActionPane: ActionPane(
//         motion: const StretchMotion(), // تأثير الحركة عند السحب
//         children: [
//           // --- زر الحذف ---
//           SlidableAction(
//             onPressed: (context) => onDelete(), // استدعاء دالة الحذف عند الضغط
//             backgroundColor: theme.colorScheme.error,
//             foregroundColor: Colors.white,
//             icon: Icons.delete,
//             label: 'حذف',
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(12.0),
//               bottomLeft: Radius.circular(12.0),
//             ),
//           ),
//           // --- زر التعديل ---
//           SlidableAction(
//             onPressed: (context) => onEdit(), // استدعاء دالة التعديل عند الضغط
//             backgroundColor: theme.colorScheme.primary,
//             foregroundColor: Colors.white,
//             icon: Icons.edit,
//             label: 'تعديل',
//           ),
//         ],
//       ),

//       // --- المحتوى الرئيسي الذي يظهر بشكل دائم ---
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//         elevation: 2.0,
//         clipBehavior: Clip.antiAlias,
//         child: InkWell(
//           onTap: onTap ?? onEdit,
//           hoverColor: theme.primaryColor.withOpacity(0.05),
//           splashColor: theme.primaryColor.withOpacity(0.1),
//           highlightColor: theme.primaryColor.withOpacity(0.1),
//           child: ListTile(
//             leading: leadingIcon != null
//                 ? CircleAvatar(
//                     backgroundColor: (leadingIconColor ?? theme.colorScheme.primary).withOpacity(0.1),
//                     child: Icon(
//                       leadingIcon,
//                       color: leadingIconColor ?? theme.colorScheme.primary,
//                       size: 22,
//                     ),
//                   )
//                 : null,
//             title: Text(
//               title,
//               style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             subtitle: subtitle != null
//                 ? Text(
//                     subtitle!,
//                     style: theme.textTheme.bodySmall,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   )
//                 : null,
            
//             // ✨ 3. (مهم) تم إزالة الـ trailing IconButton من هنا
//             // لأن الأزرار أصبحت الآن في لوحة السحب (ActionPane)
//           ),
//         ),
//       ),
//     );
//   }
// }

//// الاستخدام يبقى كما هو، لا حاجة لأي تغيير هنا
// return ReusableListItem(
//   title: level.name,
//   subtitle: 'رقم المستوى: ${level.number}',
//   leadingIcon: Icons.layers_outlined,
//   onEdit: () => _openAddDialog(level: level),
//   onDelete: () async {
//     final bool confirmDelete = await showDeleteConfirmationDialog(
//       context,
//       itemName: level.name,
//     );
//     if (confirmDelete) {
//       await _levelsRepo.delete(level.id!);
//       _refreshLevels();
//     }
//   },
// );
//---------------------------------------------------مع السحب للحذف --------------------

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rafiqi_university/shared/components/dialog_helpers.dart';

class ReusableListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final VoidCallback? onTap;

  const ReusableListItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.onEdit,
    required this.onDelete,
    this.leadingIcon,
    this.leadingIconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      key: ValueKey(title + (subtitle ?? '')),



      // --- لوحة إجراءات الحذف (السحب من اليمين) ---
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        dismissible: DismissiblePane(
          confirmDismiss: () async {
            final bool confirm = await showDeleteConfirmationDialog(
              context,
              itemName: title,
            );
            return confirm;
          },
          onDismissed: () {
            onDelete();
          },
        ),
        children: [
          SlidableAction(
            onPressed: (ctx) async {
              final bool confirm = await showDeleteConfirmationDialog(
                ctx,
                itemName: title,
              );
              if (confirm) {
                onDelete();
              }
            },
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'حذف',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
          ),
        ],
      ),

      // --- لوحة إجراءات التعديل (السحب من اليسار) ---
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'تعديل',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
            ),
          ),
        ],
      ),

      // --- المحتوى الرئيسي ---
      child: Card(
        // ... (باقي كود Card كما هو بدون تغيير)
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 2.0,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap ?? onEdit,
          hoverColor: theme.primaryColor.withOpacity(0.05),
          splashColor: theme.primaryColor.withOpacity(0.1),
          highlightColor: theme.primaryColor.withOpacity(0.1),
          child: ListTile(
            leading: leadingIcon != null
                ? CircleAvatar(
                    backgroundColor: (leadingIconColor ?? theme.colorScheme.primary).withOpacity(0.1),
                    child: Icon(
                      leadingIcon,
                      color: leadingIconColor ?? theme.colorScheme.primary,
                      size: 22,
                    ),
                  )
                : null,
            title: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
