import 'package:flutter/material.dart';

class SplashUi extends StatefulWidget {
  const SplashUi({super.key});

  @override
  State<SplashUi> createState() => _SplashUiState();
}

//////////////////////////////////////////////////////////////////////////
// ✅ Changed: SingleTickerProviderStateMixin → TickerProviderStateMixin
//////////////////////////////////////////////////////////////////////////
class _SplashUiState extends State<SplashUi> with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController
  _scaleCtrl; // ✅ now valid — multiple tickers allowed
  late final Animation<double> _pulse;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    //////////////////////////////////////////////////////////////////////////

    // Pulse controller — repeating
    //////////////////////////////////////////////////////////////////////////

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Scale controller — one-shot entrance
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _pulse = Tween<double>(
      begin: 1.0,
      end: 1.35,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _fade = Tween<double>(
      begin: 0.5,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _scale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),

            // ── Logo with pulse ring ───────────────────────────────
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ///////////////////////////////////////////////////////////
                  // Outer pulse ring
                  ///////////////////////////////////////////////////////////
                  AnimatedBuilder(
                    animation: _pulseCtrl,
                    builder: (_, __) => Transform.scale(
                      scale: _pulse.value,
                      child: Opacity(
                        opacity: _fade.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF43A047),
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Inner pulse ring
                  AnimatedBuilder(
                    animation: _pulseCtrl,
                    builder: (_, __) => Transform.scale(
                      scale: 1.0 + (_pulse.value - 1.0) * 0.6,
                      child: Opacity(
                        opacity: _fade.value * 0.7,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF66BB6A),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ////////////////////////////////////////////////////////////
                  // Logo circle
                  ///////////////////////////////////////////////////////////
                  ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF43A047),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF43A047).withOpacity(0.35),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ////////////////////////////////////////////////////////////////
            const SizedBox(height: 32),
            ///////////////////////////////////////////////////////////////
            const Text(
              'Gym Management',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your fitness, simplified',
              style: TextStyle(color: Color(0xFF81C784), fontSize: 14),
            ),

            const Spacer(flex: 3),

            const _BouncingDots(),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Bouncing dots — uses its own TickerProviderStateMixin internally
// ─────────────────────────────────────────────────────────────────────
class _BouncingDots extends StatefulWidget {
  const _BouncingDots();

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with TickerProviderStateMixin {
  final List<AnimationController> _ctrls = [];
  final List<Animation<double>> _anims = [];

  ////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      final anim = Tween<double>(
        begin: 0,
        end: -10,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
      _ctrls.add(ctrl);
      _anims.add(anim);
    }
    _startSequence();
  }

  ////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////

  Future<void> _startSequence() async {
    while (mounted) {
      for (int i = 0; i < _ctrls.length; i++) {
        if (!mounted) return;
        _ctrls[i].forward().then((_) => _ctrls[i].reverse());
        await Future.delayed(const Duration(milliseconds: 180));
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  ////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _anims[i].value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF43A047),
              ),
            ),
          ),
        );
      }),
    );
  }
}
