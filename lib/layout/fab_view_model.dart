import 'package:flutter/material.dart';

/// هذا الكلاس هو الـ ViewModel الذي يدير حالة الزر العائم (FAB).
/// باستخدام ChangeNotifier، يمكنه إخطار الـ Widgets التي تستمع إليه عند حدوث تغيير.
class FabViewModel extends ChangeNotifier {
  // متغير خاص لتخزين وظيفة الزر الحالية.
  VoidCallback? _fabAction;

  // دالة getter عامة للسماح للـ Widgets بقراءة الوظيفة الحالية.
  VoidCallback? get fabAction => _fabAction;

  /// دالة setter عامة للسماح للشاشات بتعيين أو إزالة وظيفة الزر.
  void setFabAction(VoidCallback? newAction) {
    // لا تقم بإعادة بناء الواجهة إذا لم تتغير الوظيفة.
    if (_fabAction == newAction) return;

    _fabAction = newAction;
    
    // أهم سطر:
    // أخبر كل الـ Widgets التي تستمع (مثل MainLayoutWidget) أن الحالة قد تغيرت،
    // وأنه يجب عليها إعادة بناء نفسها لتعكس هذا التغيير (إظهار/إخفاء/تغيير وظيفة الزر).
    notifyListeners();
  }
}
