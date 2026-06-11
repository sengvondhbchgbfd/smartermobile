import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_page_entity.dart';

class OnboardingPageView extends StatelessWidget {
  final OnboardingPageEntity data;
  final double animationValue;

  const OnboardingPageView({
    super.key,
    required this.data,
    this.animationValue = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /////////////////////////////////////////////////////////////
          // ── Illustration ─────────────────────────────────────────
          /////////////////////////////////////////////////////////////
          SizedBox(
            height: screenH * 0.38,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.88, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              builder: (_, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Image.asset(data.imagePath, fit: BoxFit.contain),
            ),
          ),

          const SizedBox(height: 12),

          ////////////////////////////////////////////////////////////
          // ── Decorative line ──────────────────────────────────────
          /////////////////////////////////////////////////////////////
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (_, v, __) => Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 40 * v,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          ////////////////////////////////////////////////////////////
          // ── Title ────────────────────────────────────────────────
          ////////////////////////////////////////////////////////////
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, 16 * (1 - v)),
                child: child,
              ),
            ),
            child: Text(
              data.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B5E20),
                height: 1.15,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.left,
            ),
          ),

          const SizedBox(height: 14),
          /////////////////////////////////////////////////////////////
          // ── Description ──────────────────────────────────────────
          ////////////////////////////////////////////////////////////
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - v)),
                child: child,
              ),
            ),
            child: Text(
              data.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF78909C),
                height: 1.7,
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
