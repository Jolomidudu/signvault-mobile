import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 850), () {
      if (mounted) {
        context.go(
          widget.appState.onboardingCompleted ? '/welcome' : '/onboarding',
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.primaryDark,
    body: SafeArea(
      child: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SignVaultWordmark(light: true),
              const SizedBox(height: 18),
              Text(
                'Your Signature. Your Control.',
                style: AppTypography.body.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    (
      'Your Signature.\nYour Control.',
      'Create and securely keep your signatures in one personal vault.',
      Icons.shield_outlined,
    ),
    (
      'Create. Copy. Sign.',
      'Create signatures you love and use them wherever you need them.',
      Icons.draw_outlined,
    ),
    (
      'Built for Trust.',
      'Manage your signature versions, activity and security from one place.',
      Icons.verified_user_outlined,
    ),
  ];

  void _finish() {
    widget.appState.completeOnboarding();
    context.go('/welcome');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: _finish, child: const Text('Skip')),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _page = value),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 184,
                        height: 184,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5EFE9),
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: Icon(
                          page.$3,
                          size: 78,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 44),
                      Text(
                        page.$1,
                        textAlign: TextAlign.center,
                        style: AppTypography.title,
                      ),
                      const SizedBox(height: 16),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 330),
                        child: Text(
                          page.$2,
                          textAlign: TextAlign.center,
                          style: AppTypography.body.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _page ? 24 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: index == _page
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            PrimaryButton(
              label: _page == _pages.length - 1 ? 'Get Started' : 'Next',
              onPressed: () {
                if (_page == _pages.length - 1) {
                  _finish();
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            const SignVaultWordmark(),
            const Spacer(),
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFE5EFE9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.draw_rounded,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Your Signature.\nYour Control.',
              style: AppTypography.title,
            ),
            const SizedBox(height: 14),
            Text(
              'Create, store and use your signature securely.',
              style: AppTypography.body.copyWith(color: AppColors.muted),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Create Account',
              onPressed: () => context.go('/register'),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Sign In',
              onPressed: () => context.go('/login'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}
