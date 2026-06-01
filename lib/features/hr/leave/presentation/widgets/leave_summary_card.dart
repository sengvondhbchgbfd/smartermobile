import 'package:flutter/material.dart';

class LeaveSummaryCard extends StatelessWidget {
  final Map<String, dynamic> summary;
  const LeaveSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn('Approved', summary['approved']?.toString() ?? '0'),
            _buildStatColumn('Pending', summary['pending']?.toString() ?? '0'),
            _buildStatColumn('Rejected', summary['rejected']?.toString() ?? '0'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}