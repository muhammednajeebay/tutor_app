import 'package:flutter/material.dart';

class DayNodeWidget extends StatelessWidget {
  final int dayNumber;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback? onTap;

  const DayNodeWidget({
    super.key,
    required this.dayNumber,
    required this.isCompleted,
    required this.isCurrent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: isCurrent
              ? const Color(0xFF4CA6A8) // Darker teal for current
              : const Color(0xFF5ABCBF).withOpacity(0.9), // Base teal
          borderRadius: BorderRadius.circular(30), // Pill shape
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Day',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '$dayNumber',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopicTooltipWidget extends StatelessWidget {
  final String title;
  final List<String> modules;

  const TopicTooltipWidget({
    super.key,
    required this.title,
    required this.modules,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF4CA6A8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          ...modules.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                m,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Little triangle indicator at bottom
          // (Visual only, usually handled by custom painter or shape, simplified here)
        ],
      ),
    );
  }
}
