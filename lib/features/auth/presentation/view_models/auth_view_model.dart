import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:narrata/features/auth/domain/models/app_user.dart';
import 'package:narrata/features/auth/presentation/view_models/phone_verification_state.dart';

part 'auth_view_model.g.dart';

@riverpod
Stream<AppUser?> authState(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<void> build() {
    // Initial state is data(null), meaning nothing is currently loading/erroring
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signInWithEmail(email: email, password: password);
    });
  }

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signInWithGoogle();
    });
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    void Function(String verificationId)? onCodeSent,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onCodeSent: (verificationId) {
          state = const AsyncData(null);
          // Always store in the provider so the router can pick it up
          ref
              .read(phoneVerificationStateProvider.notifier)
              .setVerification(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              );
          // Also fire the callback if the widget is still alive (Android flow)
          onCodeSent?.call(verificationId);
        },
        onFailed: (Exception e) {
          state = AsyncError(e, StackTrace.current);
        },
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signInWithOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signOut();
    });
  }
}
