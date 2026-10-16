import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SignVaultLogo extends StatelessWidget {
  const SignVaultLogo({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/sv-250.png',
    width: size,
    height: size,
    fit: BoxFit.contain,
  );
}

class SignVaultWordmark extends StatelessWidget {
  const SignVaultWordmark({
    super.key,
    this.compact = false,
    this.light = false,
  });
  final bool compact;
  final bool light;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SignVaultLogo(size: compact ? 34 : 42),
      const SizedBox(width: 10),
      Text(
        'SignVault',
        style: TextStyle(
          color: light ? Colors.white : AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.45,
        ),
      ),
    ],
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: icon == null
        ? ElevatedButton(onPressed: onPressed, child: Text(label))
        : ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          ),
  );
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      child: Text(label),
    ),
  );
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.prefixIcon,
  });
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    autofillHints: autofillHints,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
    ),
  );
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.textInputAction,
    this.autofillHints,
  });
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    obscureText: _obscure,
    textInputAction: widget.textInputAction,
    autofillHints: widget.autofillHints,
    validator: widget.validator,
    decoration: InputDecoration(
      labelText: widget.label,
      suffixIcon: IconButton(
        tooltip: _obscure ? 'Show password' : 'Hide password',
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
    ),
  );
}

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SignVaultWordmark(compact: true),
      const SizedBox(height: AppSpacing.xl),
      Text(title, style: AppTypography.title),
      const SizedBox(height: AppSpacing.sm),
      Text(
        subtitle,
        style: AppTypography.body.copyWith(color: AppColors.muted),
      ),
    ],
  );
}
