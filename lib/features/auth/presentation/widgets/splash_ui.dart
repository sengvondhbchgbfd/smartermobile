import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class SplashUi extends StatefulWidget {
  const SplashUi({super.key});

  @override
  State<SplashUi> createState() => _SplashUiState();
}

//////////////////////////////////////////////////////////////////////////
///  Facebook-style entrance: solid brand background, single fade+scale in
//////////////////////////////////////////////////////////////////////////
class _SplashUiState extends State<SplashUi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;

  //////////////////////////////////////////////////////////////////////////
  ///  INIT
  //////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _scaleIn = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////
  ///  BUILD
  //////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: Pallets.brandGradient),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: FadeTransition(
            opacity: _fadeIn,
            child: ScaleTransition(
              scale: _scaleIn,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Logo mark ─────────────────────────────────────
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Pallets.onAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Pallets.blurpleDim.withOpacity(0.35),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.dashboard_rounded,
                      size: 44,
                      color: Pallets.purpleStart,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'System App',
                    style: TextStyle(
                      color: Pallets.onAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Enjoy Our System demo',
                    style: TextStyle(
                      color: Pallets.onAccent.withOpacity(0.75),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
