import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/features/onboarding/domain/entities/onboarding_page_entity.dart';
import '../widgets/onboarding_page_view.dart';
import '../widgets/onboarding_dot_indicator.dart';
import '../widgets/onboarding_bottom_bar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  /////////////////////////////////////////////////////////
  //
  /////////////////////////////////////////////////////////

  void _onNext() {
    if (_currentPage < kOnboardingPages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go('/setup-wizard');
    }
  }

  /////////////////////////////////////////////////////////
  //
  /////////////////////////////////////////////////////////
  void _onSkip() => context.go('/setup-wizard');
  ////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      body: SafeArea(
        child: Column(
          children: [
            /////////////////////////////////////////////////////////////
            // ── Top bar ──────────────────────────────────────────
            //////////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF43A047),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'GymPro',
                        style: TextStyle(
                          color: Color(0xFF1B5E20),
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  AnimatedOpacity(
                    opacity: _currentPage < kOnboardingPages.length - 1
                        ? 1.0
                        : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: TextButton(
                      onPressed: _onSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF9E9E9E),
                      ),
                      child: const Text('Skip', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),

            /////////////////////////////////////////////////////////
            // ── Pages ────────────────────────────────────────────
            /////////////////////////////////////////////////////////
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: kOnboardingPages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) =>
                    OnboardingPageView(data: kOnboardingPages[i]),
              ),
            ),

            //////////////////////////////////////////////////////////
            // ── Dots ─────────────────────────────────────────────
            //////////////////////////////////////////////////////////
            OnboardingDotIndicator(
              count: kOnboardingPages.length,
              current: _currentPage,
            ),

            const SizedBox(height: 28),
            /////////////////////////////////////////////////////////
            // ── Bottom bar ───────────────────────────────────────
            /////////////////////////////////////////////////////////
            OnboardingBottomBar(
              currentPage: _currentPage,
              totalPages: kOnboardingPages.length,
              onNext: _onNext,
              onSkip: _onSkip,
            ),

            ////////////////////////////////////////////////////////
            //
            ////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
