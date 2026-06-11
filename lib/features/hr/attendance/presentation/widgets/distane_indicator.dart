import 'package:flutter/material.dart';

class DistanceIndicator extends StatelessWidget {
  final double distanceMeters;
  final double allowedRadius;

  const DistanceIndicator({
    super.key,
    required this.distanceMeters,
    required this.allowedRadius,
  });

  String _fmt(double m) {
    if (m >= 1000) return '${(m / 1000).toStringAsFixed(1)} km';
    return '${m.toStringAsFixed(0)} m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your distance',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                _fmt(distanceMeters),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Required within',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                _fmt(allowedRadius),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar — clamped so it never overflows visually
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (allowedRadius / distanceMeters).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.red.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Move ${_fmt(distanceMeters - allowedRadius)} closer to the office',
            style: TextStyle(fontSize: 11, color: Colors.red.shade600),
          ),
        ],
      ),
    );
  }
}

