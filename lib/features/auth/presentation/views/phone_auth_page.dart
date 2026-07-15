import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:narrata/core/utils/custom_toast.dart';

import 'package:narrata/features/auth/presentation/view_models/auth_view_model.dart';

import 'package:narrata/core/widgets/auth_divider.dart';
import 'package:narrata/core/widgets/auth_prompt.dart';
import 'package:narrata/core/widgets/auth_text_field.dart';
import 'package:narrata/core/widgets/focus_dismissible.dart';

class PhoneAuthPage extends ConsumerStatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  ConsumerState<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends ConsumerState<PhoneAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = '+91${_phoneController.text}';
      ref
          .read(authViewModelProvider.notifier)
          .verifyPhoneNumber(
            phoneNumber,
            onCodeSent: (verificationId) {
              if (!mounted) return;
              context.go(
                '/phone-auth/otp-auth',
                extra: {
                  'verificationId': verificationId,
                  'phoneNumber': phoneNumber,
                },
              );
            },
          );
    }
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
                        Icons.send_to_mobile,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Enter your phone number',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We will send you a code to verify your number.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 48),

                      Form(
                        key: _formKey,
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthTextField(
                                controller: _phoneController,
                                hintText: 'Phone Number',
                                prefixIcon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                prefixText: '+91 ',
                                autofillHints: const [
                                  AutofillHints.telephoneNumber,
                                ],
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(),
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (value.length < 10) {
                                    return 'Please enter a valid 10-digit number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              ElevatedButton(
                                onPressed: authState.isLoading ? null : _submit,
                                child: authState.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Send OTP'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      const AuthDivider(),
                      const SizedBox(height: 24),

                      // Social Auth Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            context,
                            iconWidget: SvgPicture.asset(
                              'assets/icons/google.svg',
                              width: 22,
                              height: 22,
                            ),
                            onPressed: () {
                              context.go('/home');
                            },
                          ),
                          const SizedBox(width: 16),
                          _buildSocialButton(
                            context,
                            iconWidget: Icon(
                              Icons.email_outlined,
                              size: 24,
                              color: colorScheme.onSurface,
                            ),
                            onPressed: () {
                              context.push('/login');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Sign Up Link
                      AuthPrompt(
                        promptText: "Don't have an account?",
                        buttonText: 'Sign Up',
                        onPressed: () {
                          context.push('/signup');
                        },
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

  Widget _buildSocialButton(
    BuildContext context, {
    required Widget iconWidget,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56, // Fixed width and height for consistency
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        child: iconWidget,
      ),
    );
  }
}
