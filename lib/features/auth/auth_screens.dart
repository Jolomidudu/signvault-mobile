import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_widgets.dart';

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) {
    return 'Enter your email address';
  }
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if ((value ?? '').length < 8) return 'Use at least 8 characters';
  return null;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthHeader(
            title: 'Welcome back',
            subtitle: 'Sign in to your personal signature vault.',
          ),
          const SizedBox(height: 30),
          AppTextField(
            controller: _email,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.next,
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          PasswordField(
            controller: _password,
            label: 'Password',
            autofillHints: const [AutofillHints.password],
            textInputAction: TextInputAction.done,
            validator: (value) =>
                (value ?? '').isEmpty ? 'Enter your password' : null,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.go('/forgot-password'),
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Sign In',
            onPressed: () {
              if (_formKey.currentState!.validate()) widget.appState.signIn();
            },
          ),
          const SizedBox(height: 22),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'New to SignVault? ',
                  style: AppTypography.body.copyWith(color: AppColors.muted),
                ),
                GestureDetector(
                  onTap: () => context.go('/register'),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      (value ?? '').trim().isEmpty ? 'This field is required' : null;

  @override
  Widget build(BuildContext context) => AuthScaffold(
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthHeader(
            title: 'Create your account',
            subtitle: 'Set up your personal signature vault.',
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: _first,
            label: 'First name',
            autofillHints: const [AutofillHints.givenName],
            textInputAction: TextInputAction.next,
            validator: _required,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _last,
            label: 'Last name',
            autofillHints: const [AutofillHints.familyName],
            textInputAction: TextInputAction.next,
            validator: _required,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _email,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.next,
            validator: validateEmail,
          ),
          const SizedBox(height: 12),
          PasswordField(
            controller: _password,
            label: 'Password',
            autofillHints: const [AutofillHints.newPassword],
            textInputAction: TextInputAction.next,
            validator: validatePassword,
          ),
          const SizedBox(height: 12),
          PasswordField(
            controller: _confirm,
            label: 'Confirm password',
            textInputAction: TextInputAction.done,
            validator: (value) =>
                value != _password.text ? 'Passwords do not match' : null,
          ),
          const SizedBox(height: 22),
          PrimaryButton(
            label: 'Create Account',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.go('/verify-email');
              }
            },
          ),
          const SizedBox(height: 18),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppTypography.body.copyWith(color: AppColors.muted),
                ),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthHeader(
            title: 'Reset your password',
            subtitle: 'Enter your email and we’ll share the next steps.',
          ),
          const SizedBox(height: 28),
          AppTextField(
            controller: _email,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: validateEmail,
          ),
          const SizedBox(height: 20),
          if (_sent) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1EB),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Text(
                'If an account exists for this email, reset instructions will be sent.',
                style: AppTypography.body,
              ),
            ),
            const SizedBox(height: 16),
          ],
          PrimaryButton(
            label: 'Send Reset Instructions',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() => _sent = true);
              }
            },
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Back to Sign In'),
            ),
          ),
        ],
      ),
    ),
  );
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _complete = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthHeader(
            title: 'Choose a new password',
            subtitle: 'Use at least 8 characters for your new password.',
          ),
          const SizedBox(height: 28),
          PasswordField(
            controller: _password,
            label: 'New password',
            validator: validatePassword,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          PasswordField(
            controller: _confirm,
            label: 'Confirm new password',
            validator: (value) =>
                value != _password.text ? 'Passwords do not match' : null,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 20),
          if (_complete)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Your password has been updated.',
                style: TextStyle(color: AppColors.success),
              ),
            ),
          PrimaryButton(
            label: 'Update Password',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() => _complete = true);
              }
            },
          ),
          Center(
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Back to Sign In'),
            ),
          ),
        ],
      ),
    ),
  );
}

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) => AuthScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthHeader(
          title: 'Check your inbox',
          subtitle:
              'A verification message is ready for the email address you provided.',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1EB),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Text(
            'Email delivery is not connected in this preview. You can continue to explore the app.',
            style: AppTypography.body,
          ),
        ),
        const SizedBox(height: 18),
        PrimaryButton(
          label: 'Continue when verified',
          onPressed: appState.signIn,
        ),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text('Resend verification'),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () => context.go('/register'),
            child: const Text('Change email'),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () => context.go('/welcome'),
            child: const Text('Back'),
          ),
        ),
      ],
    ),
  );
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontal = constraints.maxWidth < 440
              ? 24.0
              : (constraints.maxWidth - 392) / 2;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: child,
            ),
          );
        },
      ),
    ),
  );
}
