import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  FirebaseAuth get firebaseAuth => _auth;
  FirebaseFirestore get firebaseFirestore => _firestore;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _user = _auth.currentUser;
    
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _safeNotifyListeners();
    });
  }

  void _safeNotifyListeners() {
    try {
      notifyListeners();
    } catch (e) {
      debugPrint('Error in notifyListeners: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _safeNotifyListeners();
  }

  Future<String> registerWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      
      debugPrint('🔄 Starting registration...');

      if (email.trim().isEmpty || password.isEmpty || username.trim().isEmpty) {
        return 'กรุณากรอกข้อมูลให้ครบถ้วน';
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      }

      if (password.length < 6) {
        return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
      }

      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      
      final User? newUser = result.user;

      if (newUser != null) {
        _user = newUser;
        debugPrint('✅ User created: ${newUser.uid}');
        
        try {

          await newUser.updateDisplayName(username.trim());
          
          await _firestore.collection('users').doc(newUser.uid).set({
            'uid': newUser.uid,
            'username': username.trim(),
            'email': email.trim().toLowerCase(),
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'isActive': true,
          });
          
          debugPrint('✅ User data saved to Firestore');

          await newUser.reload();
          _user = _auth.currentUser;
          
          return 'ลงทะเบียนสำเร็จ';
          
        } catch (firestoreError) {
          debugPrint('⚠️ Firestore error: $firestoreError');

          return 'ลงทะเบียนสำเร็จ';
        }
        
      } else {
        return 'การสร้างบัญชีไม่สำเร็จ';
      }
      
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ FirebaseAuthException: ${e.code}');
      return _getFirebaseErrorMessage(e);
    } catch (e) {
      debugPrint('❌ General error: $e');
      return 'เกิดข้อผิดพลาดในการสร้างบัญชี';
    } finally {
      _setLoading(false);
    }
  }

  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      
      debugPrint('🔄 Attempting login for: $email');
      
      if (email.trim().isEmpty || password.isEmpty) {
        return 'กรุณากรอกอีเมลและรหัสผ่าน';
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      }

      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      
      _user = result.user;
      
      if (_user != null) {
        debugPrint('✅ Login successful: ${_user!.email}');
        
        try {
          await _firestore.collection('users').doc(_user!.uid).update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
          debugPrint('✅ Last login updated');
        } catch (e) {
          debugPrint('⚠️ Failed to update last login: $e');
        }
        
        return 'เข้าสู่ระบบสำเร็จ';
      } else {
        debugPrint('❌ Login failed: User is null');
        return 'เข้าสู่ระบบไม่สำเร็จ';
      }
      
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Login FirebaseAuthException: ${e.code} - ${e.message}');
      _user = null;
      return _getFirebaseErrorMessage(e);
    } catch (e) {
      debugPrint('❌ Login general error: $e');
      _user = null;
      return 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
    } finally {
      _setLoading(false);
    }
  }

  Future<String> logout() async {
    try {
      _setLoading(true);
      
      await _auth.signOut();
      _user = null;
      
      return 'ออกจากระบบสำเร็จ';
    } catch (e) {
      debugPrint('❌ Logout error: $e');
      return 'เกิดข้อผิดพลาดในการออกจากระบบ';
    } finally {
      _setLoading(false);
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'รหัสผ่านไม่ปลอดภัย ต้องอย่างน้อย 6 ตัวอักษร';
      case 'email-already-in-use':
        return 'อีเมลนี้ถูกใช้แล้ว กรุณาใช้อีเมลอื่น';
      case 'invalid-email':
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      case 'user-not-found':
        return 'ไม่พบบัญชีผู้ใช้นี้';
      case 'wrong-password':
        return 'รหัสผ่านไม่ถูกต้อง';
      case 'user-disabled':
        return 'บัญชีนี้ถูกระงับการใช้งาน';
      case 'invalid-credential':
        return 'ข้อมูลการเข้าสู่ระบบไม่ถูกต้อง';
      case 'too-many-requests':
        return 'มีการพยายามเข้าสู่ระบบมากเกินไป กรุณารอสักครู่';
      case 'network-request-failed':
        return 'เกิดปัญหาการเชื่อมต่อ กรุณาตรวจสอบอินเทอร์เน็ท';
      case 'operation-not-allowed':
        return 'การดำเนินการนี้ไม่ได้รับอนุญาต';
      case 'requires-recent-login':
        return 'กรุณาเข้าสู่ระบบใหม่ก่อนดำเนินการ';
      default:
        debugPrint('Unhandled Firebase error: ${e.code} - ${e.message}');
        return 'เกิดข้อผิดพลาด: ${e.code}';
    }
  }
}
