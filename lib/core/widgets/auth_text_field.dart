import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class AuthTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? prefixText;
  final Iterable<String>? autofillHints;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.autofillHints,
    this.controller,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField>
    with SingleTickerProviderStateMixin {
  late bool _obscureText;
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();
  Timer? _errorTimer;
  bool _forceClearError = false;

  late AnimationController _fadeController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_fadeController);
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  String? _handleValidation(String? value) {
    if (_forceClearError) {
      _forceClearError = false;
      return null;
    }
    final error = widget.validator?.call(value);
    if (error != null) {
      _fadeController.reset();
      _errorTimer?.cancel();
      _errorTimer = Timer(const Duration(milliseconds: 2500), () {
        if (mounted) {
          _fadeController.forward().then((_) {
            if (mounted) {
              _forceClearError = true;
              _fieldKey.currentState?.validate();
            }
          });
        }
      });
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return TextFormField(
          key: _fieldKey,
          controller: widget.controller,
          validator: _handleValidation,
          onChanged: (value) {
            _errorTimer?.cancel();
            _fadeController.reset();
            if (_fieldKey.currentState?.hasError ?? false) {
              _forceClearError = true;
              _fieldKey.currentState?.validate();
            }
          },
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          autofillHints: widget.autofillHints,
          autovalidateMode: AutovalidateMode.disabled,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: Icon(widget.prefixIcon),
            prefixText: widget.prefixText,
            counterText: '', // Hide character counter
            errorStyle: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.error.withValues(alpha: _opacityAnimation.value),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
