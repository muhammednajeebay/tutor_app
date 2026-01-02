import 'package:flutter/material.dart';
import 'package:tutor_app/data/models/home_model.dart';
import 'package:tutor_app/utils/const/app_colors.dart';
import 'package:tutor_app/utils/const/app_strings.dart';

class ActiveCourseCard extends StatelessWidget {
  final ActiveCourse course;

  const ActiveCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final progress = course.progress ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A5F7F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Circular progress
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: progress / 100,
                    strokeWidth: 6,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFA500),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '$progress%',
                    style: const TextStyle(
                      color: Color(0xFFFFA500),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Course info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFFFFA500),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course.testsCompleted}/${course.totalTests} Tests',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                      
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          AppStrings.continueButton,
                          // style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          AppStrings.shiftCourse,
                          // style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
