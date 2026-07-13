import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'phone_verification_state.g.dart';

class PhoneVerificationData {
  final String verificationId;
  final String phoneNumber;

  PhoneVerificationData({
    required this.verificationId,
    required this.phoneNumber,
  });
}

@Riverpod(keepAlive: true)
class PhoneVerificationState extends _$PhoneVerificationState {
  @override
  PhoneVerificationData? build() => null;

  void setVerification({
    required String verificationId,
    required String phoneNumber,
  }) {
    state = PhoneVerificationData(
      verificationId: verificationId,
      phoneNumber: phoneNumber,
    );
  }

  void clear() {
    state = null;
  }
}
