import 'package:flutter/material.dart';

// هذا هو الـ Widget الخاص بشريط التنقل السفلي
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: theme.bottomAppBarTheme.color ?? theme.colorScheme.surface,
      surfaceTintColor: theme.bottomAppBarTheme.surfaceTintColor,
      elevation: 10.0,
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // تم نقل دالة _buildNavItem إلى هنا وأصبحت خاصة بهذا الكلاس
          _buildNavItem(context, Icons.home, 'الرئيسية', 0),
          _buildNavItem(context, Icons.notifications, 'الإشعارات', 1),
          const SizedBox(width: 40), // مسافة للزر العائم
          _buildNavItem(context, Icons.person, 'المواد الدراسية', 2),
          _buildNavItem(context, Icons.settings, 'الإعدادات', 3),
          // _buildNavItem(context, Icons.settings, 'إضافة البيانات الأساسية',4),
        ],
      ),
    );
  }

  // دالة بناء كل أيقونة، أصبحت الآن جزءاً من هذا الكلاس
  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final theme = Theme.of(context);
    final bool isSelected = currentIndex == index;

    final Color activeColor = theme.colorScheme.primary;
    final Color inactiveColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: () => onItemTapped(index),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
