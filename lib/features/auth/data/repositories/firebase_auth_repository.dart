import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/auth/domain/models/app_user.dart';
import 'package:narrata/features/auth/domain/repositories/auth_repository.dart';

part 'firebase_auth_repository.g.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository(this._firebaseAuth, this._firestore);

  AppUser? _mapUser(User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw Exception('Invalid email or password.');
      } else if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided.');
      }
      throw Exception(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Update the user's profile with their name
        await user.updateProfile(displayName: name);

        // Create the user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': name,
          'email': email,
          'uid': user.uid,
          'authMethod': 'email',
          'credits': 3,
          'isOnboardingCompleted': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for that email.');
      }
      throw Exception(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;
      final authClient = await googleUser.authorizationClient
          .authorizationForScopes(['email', 'profile']);

      final credential = GoogleAuthProvider.credential(
        accessToken: authClient?.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null &&
          userCredential.additionalUserInfo?.isNewUser == true) {
        // Create the user document in Firestore for new users
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': user.displayName ?? '',
          'email': user.email ?? '',
          'uid': user.uid,
          'authMethod': 'google',
          'credits': 3,
          'isOnboardingCompleted': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return;
      }
      throw Exception(e.description ?? 'Google Sign-In failed.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw Exception(
          'An account already exists with the same email address but different sign-in credentials.',
        );
      } else if (e.code == 'invalid-credential') {
        throw Exception(
          'Error occurred while accessing credentials. Try again.',
        );
      }
      throw Exception(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(Exception e) onFailed,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-resolution on Android.
        // If this happens, we can automatically sign them in.
        try {
          final userCredential = await _firebaseAuth.signInWithCredential(
            credential,
          );
          await _checkAndCreateUserDoc(userCredential.user);
        } catch (e) {
          onFailed(Exception(e.toString()));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          onFailed(Exception('The provided phone number is not valid.'));
        } else {
          onFailed(Exception(e.message ?? 'Verification failed.'));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // We handle timeout manually via timer in the UI
      },
    );
  }

  @override
  Future<void> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      await _checkAndCreateUserDoc(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw Exception('The code you entered is incorrect.');
      } else if (e.code == 'invalid-verification-id') {
        throw Exception('Verification session expired. Please try again.');
      }
      throw Exception(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _checkAndCreateUserDoc(User? user) async {
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        // Create the user document in Firestore for new users via phone auth
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': user.displayName ?? '',
          'email': user.email ?? '',
          'uid': user.uid,
          'phone': user.phoneNumber ?? '',
          'authMethod': 'phone',
          'credits': 3,
          'isOnboardingCompleted': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  @override
  Future<void> updateName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No user logged in.');

    try {
      await user.updateDisplayName(name);
      await _firestore.collection('users').doc(user.uid).update({
        'fullName': name,
      });
    } catch (e) {
      throw Exception('Failed to update name: $e');
    }
  }

  @override
  Future<void> updateEmail(String email) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No user logged in.');

    try {
      // Just updating the database for Phone Auth accounts.
      await _firestore.collection('users').doc(user.uid).update({
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to update email: $e');
    }
  }

  @override
  Future<void> updatePhone(String phone) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No user logged in.');

    try {
      // As requested, only updating the database for Google/Email accounts.
      await _firestore.collection('users').doc(user.uid).update({
        'phone': phone,
      });
    } catch (e) {
      throw Exception('Failed to update phone number: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
}
