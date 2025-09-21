// import 'package:flutter/material.dart';
// import 'package:badges/badges.dart' as badges;

// class NotificationBellIcon extends StatelessWidget {
//   final int notificationCount;
//   final VoidCallback onTap;

//   const NotificationBellIcon({
//     super.key,
//     required this.notificationCount,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return badges.Badge(
//       // إظهار الشارة فقط إذا كان عدد الإشعارات أكبر من صفر
//       showBadge: notificationCount > 0,
//       // محتوى الشارة (عدد الإشعارات)
//       badgeContent: Text(
//         notificationCount > 99 ? '99+' : notificationCount.toString(),
//         style: const TextStyle(color: Colors.white, fontSize: 10),
//       ),
//       // الأيقونة التي ستظهر الشارة فوقها
//       child: IconButton(
//         icon: const Icon(Icons.notifications),
//         onPressed: onTap,
//       ),
//     );
//   }
// }