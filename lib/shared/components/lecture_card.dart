// lib/shared/components/lecture_card.dart

import 'package:flutter/material.dart';

class LectureCard extends StatelessWidget {
  // 1. تعريف كل البيانات التي سيعرضها الكارت
  final String subjectName;
  final String lectureTypeName;
  final String? teacherName;
  final String? classRoomName;
  final String? timeSlotName;
  final int isCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const LectureCard({
    super.key,
    required this.subjectName,
    required this.lectureTypeName,
    this.teacherName,
    this.classRoomName,
    this.timeSlotName,
    required this.isCompleted,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 2. تحديد لون الكارت بناءً على حالة المحاضرة
    final cardColor = (isCompleted == 1)
        ? Colors.blue.shade700
        : Colors.amber.shade800; // اللون الأصفر للمحاضرة غير المكتملة
    final textColor = Colors.white;

    // ✨ 4. لف الـ Card بـ InkWell لجعله قابلاً للنقر
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12), // ليتناسب مع شكل الكارت
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        color: cardColor,
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- السطر الأول: اسم المادة ونوع المحاضرة ---
            Text(
              '$subjectName - $lectureTypeName',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // --- السطر الثاني: المدرس والقاعة ---
            // نستخدم Row لعرضهما جنبًا إلى جنب
            Row(
              children: [
                // أيقونة المدرس
                Icon(Icons.person_outline, color: textColor, size: 18),
                const SizedBox(width: 4),
                // اسم المدرس (مع قيمة افتراضية)
                Expanded(
                  child: Text(
                    'المعلم: ${teacherName ?? 'غير محدد'}',
                    style: TextStyle(color: textColor, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                // أيقونة القاعة
                Icon(Icons.location_on_outlined, color: textColor, size: 18),
                const SizedBox(width: 4),
                // اسم القاعة (مع قيمة افتراضية)
                Expanded(
                  child: Text(
                    'القاعة: ${classRoomName ?? 'غير محددة'}',
                    style: TextStyle(color: textColor, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // --- السطر الثالث: الفترة والوقت ---
            Row(
              children: [
                Icon(Icons.access_time_outlined, color: textColor, size: 18),
                const SizedBox(width: 4),
                Text(
                  'الوقت: ${timeSlotName ?? 'غير محدد'}',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // --- السطر الرابع: أزرار التحكم ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // زر التعديل
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: textColor),
                  onPressed: onEdit,
                  tooltip: 'تعديل',
                ),
                // زر الحذف
                IconButton(
                  icon: Icon(Icons.delete_outline, color: textColor),
                  onPressed: onDelete,
                  tooltip: 'حذف',
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );}
}
