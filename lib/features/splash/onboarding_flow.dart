import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller = PageController();
  int _currentPage = 0;

  static const _pageColors = [
    Color(0xFFDAD3C8),
    Color(0xFFFFE5DE),
    Color(0xFFDCF6E6),
  ];

  static const _pages = [
    (
      'Your Signature.\nYour Control.',
      'Create and securely keep your signatures in one personal vault.',
      'assets/images/onboard_illustration_1.png',
    ),
    (
      'Create. Copy. Sign.',
      'Create signatures you love and use them wherever you need them.',
      'assets/images/onboard_illustration_2.png',
    ),
    (
      'Built for Trust.',
      'Manage your signature versions, activity and security from one place.',
      'assets/images/onboard_illustration_3.png',
    ),
  ];

  void _finish() {
    widget.appState.completeOnboarding();
    context.go('/welcome');
  }

  AnimatedContainer _buildDots({required int index}) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeIn,
    width: _currentPage == index ? 20 : 10,
    height: 10,
    margin: const EdgeInsets.only(right: 5),
    decoration: const BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final compact = width <= 550;

    return Scaffold(
      backgroundColor: _pageColors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
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
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(page.$3, fit: BoxFit.contain),
                        ),
                        SizedBox(height: height >= 840 ? 40 : 24),
                        Text(
                          page.$1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w600,
                            fontSize: compact ? 30 : 35,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          page.$2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w300,
                            fontSize: compact ? 17 : 25,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildDots(index: index),
                    ),
                  ),
                  if (_currentPage == _pages.length - 1)
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _finish,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 30 : width * 0.2,
                              vertical: compact ? 20 : 25,
                            ),
                            textStyle: TextStyle(
                              fontSize: compact ? 13 : 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('GET STARTED'),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () =>
                                _controller.jumpToPage(_pages.length - 1),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: compact ? 13 : 17,
                              ),
                            ),
                            child: const Text('SKIP'),
                          ),
                          ElevatedButton(
                            onPressed: () => _controller.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: const Size(0, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: compact ? 20 : 25,
                              ),
                              textStyle: TextStyle(
                                fontSize: compact ? 13 : 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('NEXT'),
                          ),
                        ],
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
