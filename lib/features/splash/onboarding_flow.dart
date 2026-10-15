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
    duration: const Duration(milliseconds: 850),
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
    backgroundColor: AppColors.surface,
    body: SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.sizeOf(context).height * 0.34,
            child: const IgnorePointer(
              child: CustomPaint(painter: _SplashWavePainter()),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SignVaultLogo(size: 132),
                  const SizedBox(height: 22),
                  const Text(
                    'SignVault',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your Signature. Your Control.',
                    style: AppTypography.body.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: Center(
              child: SizedBox(
                width: 180,
                height: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: AppColors.border),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) => Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: _controller.value,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.accent, AppColors.primary],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SplashWavePainter extends CustomPainter {
  const _SplashWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backWave = Path()
      ..moveTo(0, size.height * 0.12)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.38,
        size.width * 0.43,
        size.height * 0.78,
        size.width * 0.67,
        size.height * 0.57,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height * 0.44,
        size.width * 0.9,
        size.height * 0.2,
        size.width,
        size.height * 0.16,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      backWave,
      Paint()..color = AppColors.accentSoft.withValues(alpha: 0.48),
    );

    final frontWave = Path()
      ..moveTo(0, size.height * 0.38)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.57,
        size.width * 0.43,
        size.height * 0.91,
        size.width * 0.68,
        size.height * 0.68,
      )
      ..cubicTo(
        size.width * 0.83,
        size.height * 0.54,
        size.width * 0.92,
        size.height * 0.4,
        size.width,
        size.height * 0.35,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      frontWave,
      Paint()..color = AppColors.accentSoft.withValues(alpha: 0.72),
    );

    final highlight = Path()
      ..moveTo(0, size.height * 0.38)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.57,
        size.width * 0.43,
        size.height * 0.91,
        size.width * 0.68,
        size.height * 0.68,
      )
      ..cubicTo(
        size.width * 0.83,
        size.height * 0.54,
        size.width * 0.92,
        size.height * 0.4,
        size.width,
        size.height * 0.35,
      );
    canvas.drawPath(
      highlight,
      Paint()
        ..color = AppColors.accent.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_SplashWavePainter oldDelegate) => false;
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
      'assets/images/onboarding_signing_1.jpg',
    ),
    (
      'Create. Copy. Sign.',
      'Create signatures you love and use them wherever you need them.',
      'assets/images/onboarding_signing_2.jpg',
    ),
    (
      'Built for Trust.',
      'Manage your signature versions, activity and security from one place.',
      'assets/images/onboarding_signing_3.jpg',
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
    body: PageView.builder(
      controller: _controller,
      onPageChanged: (value) => setState(() => _page = value),
      itemCount: _pages.length,
      itemBuilder: (context, index) {
        final page = _pages[index];
        return LayoutBuilder(
          builder: (context, constraints) => Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(page.$3, fit: BoxFit.cover),
              ColoredBox(color: Colors.white.withValues(alpha: 0.2)),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        const SignVaultLogo(size: 34),
                        const SizedBox(width: 10),
                        const Text(
                          'SignVault',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _finish,
                          child: const Text('Skip'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: MediaQuery.paddingOf(context).bottom + 14,
                height: constraints.maxHeight * 0.52,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            page.$1,
                            style: AppTypography.title.copyWith(
                              fontSize: 32,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            page.$2,
                            style: AppTypography.body.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pages.length,
                              (dotIndex) => AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: dotIndex == _page ? 24 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: dotIndex == _page
                                      ? AppColors.primary
                                      : AppColors.border,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            label: _page == _pages.length - 1
                                ? 'Get Started'
                                : 'Next',
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
                ),
              ),
            ],
          ),
        );
      },
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
            const SignVaultLogo(size: 84),
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
