import 'package:flutter/material.dart';

class UploadLoadingIndicator extends StatefulWidget {
  final int percentage; // 0–100

  const UploadLoadingIndicator({super.key, required this.percentage});

  @override
  State<UploadLoadingIndicator> createState() => _UploadLoadingIndicatorState();
}

class _UploadLoadingIndicatorState extends State<UploadLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final delay = i * 0.2;
                final value = ((_controller.value - delay) % 1.0).clamp(
                  0.0,
                  1.0,
                );
                final opacity = (value < 0.5) ? value * 2 : (1.0 - value) * 2;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(
                      0xFF7F77DD,
                    ).withOpacity(0.3 + opacity * 0.7),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          'Uploading... ${widget.percentage}%',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF7F77DD),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: widget.percentage / 100,
          backgroundColor: Colors.grey.shade200,
          color: const Color(0xFF7F77DD),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
