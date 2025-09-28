// lib/services/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart'; // ✨ 1. استيراد مكتبة Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  // إنشاء نسخ وحيدة من الخدمات لاستخدامها في التطبيق
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // ✨ 2. إنشاء نسخة من Firestore

  // Getter للوصول إلى المستخدم الحالي بسهولة
  User? get currentUser => _auth.currentUser;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? get userDocumentStream {
  // إذا لم يكن هناك مستخدم مسجل، أرجع null
  if (currentUser == null) return null;
  // إذا كان هناك مستخدم، أرجع Stream للمستند الخاص به
  return _firestore.collection('users').doc(currentUser!.uid).snapshots();
}
  // --- دالة لإنشاء حساب جديد مع إنشاء ملف شخصي في Firestore ---
  Future<User?> createUserAndProfile({ // ✨ 3. تم تغيير اسم الدالة وإضافة fullName
    required String email,
    required String password,
    required String fullName,
    required BuildContext context,
  }) async {
    try {
      // الخطوة 1: إنشاء الحساب في خدمة المصادقة
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? newUser = userCredential.user;

      // الخطوة 2: إذا نجح إنشاء الحساب، قم بإنشاء مستند له في Firestore
      if (newUser != null) {
        await _firestore.collection('users').doc(newUser.uid).set({
          'user_id': newUser.uid,
          'full_name': fullName.trim(),
          'username': email.trim(), // استخدام الإيميل كاسم مستخدم مبدئي
          'email': email.trim(),
          'role': 'student', // ✨ 4. تحديد الدور الافتراضي "طالب"
          'created_at': FieldValue.serverTimestamp(), // إضافة تاريخ الإنشاء
          // يمكنك إضافة الحقول الأخرى (dept_id, level_id) هنا كـ null مبدئياً
          'dept_id': null,
          'level_id': null,
        });
      }
      
      // في حال النجاح، أرجع كائن المستخدم الجديد
      return newUser;

    } on FirebaseAuthException catch (e) {
      // معالجة الأخطاء الشائعة وعرض رسائل واضحة للمستخدم (تبقى كما هي)
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور ضعيفة جدًا.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'هذا البريد الإلكتروني مستخدم بالفعل.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'البريد الإلكتروني غير صالح.';
      } else {
        errorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  // --- دالة لتسجيل الدخول ---
  // (هذه الدالة تبقى كما هي تماماً بدون أي تغيير)
  Future<User?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
      } else {
        errorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  // --- دالة لتسجيل الخروج ---
  // (تبقى كما هي)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- Stream لمراقبة حالة المستخدم ---
  // (يبقى كما هو)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
