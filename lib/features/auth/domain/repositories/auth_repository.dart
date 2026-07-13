import 'package:narrata/features/auth/domain/models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(Exception e) onFailed,
  });

  Future<void> signInWithOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> updateName(String name);
  Future<void> updateEmail(String email);
  Future<void> updatePhone(String phone);

  Future<void> signOut();
}
