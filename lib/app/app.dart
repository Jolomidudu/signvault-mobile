import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/auth_screens.dart';
import '../features/home/app_shell.dart';
import '../features/splash/onboarding_flow.dart';
import 'app_state.dart';

class SignVaultApp extends StatefulWidget {
  const SignVaultApp({
    super.key,
    this.appState,
    this.initialLocation = '/onboarding',
  });

  final AppState? appState;
  final String initialLocation;

  @override
  State<SignVaultApp> createState() => _SignVaultAppState();
}

class _SignVaultAppState extends State<SignVaultApp> {
  late final AppState _appState = widget.appState ?? AppState();
  late final GoRouter _router = GoRouter(
    initialLocation: widget.initialLocation,
    refreshListenable: _appState,
    redirect: (context, state) {
      final authenticated = _appState.session == SessionStatus.authenticated;
      final protected =
          state.matchedLocation.startsWith('/app') ||
          state.matchedLocation == '/signatures/new';
      if (protected && !authenticated) return '/welcome';
      if (authenticated && !protected) return '/app/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(appState: _appState),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(appState: _appState),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => VerifyEmailScreen(appState: _appState),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(appState: _appState, child: child),
        routes: [
          GoRoute(
            path: '/app/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/app/vault',
            builder: (context, state) => const VaultScreen(),
          ),
          GoRoute(
            path: '/app/activity',
            builder: (context, state) => const ActivityScreen(),
          ),
          GoRoute(
            path: '/app/profile',
            builder: (context, state) => ProfileScreen(appState: _appState),
          ),
        ],
      ),
      GoRoute(
        path: '/signatures/new',
        builder: (context, state) => const CreateSignatureScreen(),
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    if (widget.appState == null) _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'SignVault',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    routerConfig: _router,
  );
}
