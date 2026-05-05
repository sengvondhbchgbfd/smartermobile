import 'package:flutter/material.dart';

class OnboardingBottomBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  ////////////////////////////////////////
  //
  ///////////////////////////////////////

  const OnboardingBottomBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  ///////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////

  bool get _isLast => currentPage == totalPages - 1;

  ///////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ////////////////////////////////////////////////////////////
          // ── Primary button ───────────────────────────────────────
          /////////////////////////////////////////////////////////////
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF43A047),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF43A047).withOpacity(0.30),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onNext,
                borderRadius: BorderRadius.circular(14),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _isLast ? 'GET STARTED' : 'NEXT',
                      key: ValueKey(_isLast),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),
          //////////////////////////////////////////////////////////////
          // ── Skip / already have account ──────────────────────────
          ////////////////////////////////////////////////////////////
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isLast
                ? TextButton(
                    key: const ValueKey('login'),
                    onPressed: onSkip,
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : TextButton(
                    key: const ValueKey('skip'),
                    onPressed: onSkip,
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
