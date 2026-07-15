import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:narrata/core/utils/custom_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:narrata/features/auth/presentation/view_models/auth_view_model.dart';

import 'package:narrata/core/widgets/focus_dismissible.dart';

class OtpAuthPage extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpAuthPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpAuthPage> createState() => _OtpAuthPageState();
}

class _OtpAuthPageState extends ConsumerState<OtpAuthPage> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  Timer? _timer;
  int _resendSeconds = 30;
  String _currentVerificationId = '';

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() => _resendSeconds = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    final otp = _pinController.text;
    if (otp.length == 6) {
      ref
          .read(authViewModelProvider.notifier)
          .signInWithOtp(verificationId: _currentVerificationId, smsCode: otp);
    }
  }

  void _resendCode() {
    if (_resendSeconds > 0) return;

    ref
        .read(authViewModelProvider.notifier)
        .verifyPhoneNumber(
          widget.phoneNumber,
          onCodeSent: (newVerificationId) {
            setState(() {
              _currentVerificationId = newVerificationId;
            });
            _startResendTimer();
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AsyncValue<void>>(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (ModalRoute.of(context)?.isCurrent != true) return;
          CustomToast.showError(context, error.toString().replaceAll('Exception: ', ''));
        },
      );
    });

    ref.listen<String?>(autoRetrievedSmsCodeProvider, (previous, next) {
      if (next != null && next.isNotEmpty) {
        _pinController.text = next;
        if (next.length == 6) {
          _verifyOtp();
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(autoRetrievedSmsCodeProvider.notifier).setCode(null);
        });
      }
    });

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 64,
      textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: colorScheme.primary, width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
    );

    return FocusDismissible(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.message_outlined,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Verification Code',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the 6-digit code sent to your phone.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Center(
                        child: Pinput(
                          length: 6,
                          controller: _pinController,
                          focusNode: _focusNode,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          separatorBuilder: (index) => const SizedBox(width: 8),
                          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          enableIMEPersonalizedLearning: true,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onCompleted: (pin) => _verifyOtp(),
                        ),
                      ),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : _verifyOtp,
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Verify'),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive code? ",
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed:
                                _resendSeconds == 0 && !authState.isLoading
                                ? _resendCode
                                : null,
                            child: Text(
                              _resendSeconds > 0
                                  ? 'Resend in ${_resendSeconds}s'
                                  : 'Resend',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
     ),
    );
  }
}
