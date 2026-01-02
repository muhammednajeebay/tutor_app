import 'package:flutter/material.dart';

class DayNodeWidget extends StatelessWidget {
  final int dayNumber;
  final bool isCompleted;
  final bool isCurrent;
  final bool isSelected;
  final VoidCallback? onTap;

  const DayNodeWidget({
    super.key,
    required this.dayNumber,
    required this.isCompleted,
    required this.isCurrent,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3A8A8C) // Darker when selected
              : isCurrent
                  ? const Color(0xFF4CA6A8) // Darker teal for current
                  : const Color(0xFF5ABCBF).withOpacity(0.9), // Base teal
          borderRadius: BorderRadius.circular(30), // Pill shape
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.2 : 0.1),
              blurRadius: isSelected ? 8 : 4,
              offset: Offset(0, isSelected ? 4 : 2),
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
  final VoidCallback? onClose;

  const TopicTooltipWidget({
    super.key,
    required this.title,
    required this.modules,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
            ],
          ),
        ),
        // Close button
        if (onClose != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}