
import 'package:flutter/material.dart';
import 'package:tutor_app/core/widgets/curved_header_painter.dart';
import 'package:tutor_app/data/models/home_model.dart';
import 'package:tutor_app/utils/const/app_colors.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    super.key,
    required this.homeData,
  });

  final HomeModel? homeData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: CurvedHeaderPainter(color: AppColors.primary),
          child: SizedBox(height: 140, width: double.infinity),
        ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                homeData?.user?.greeting ?? 'Good Morning',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  if (homeData?.user?.streak != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Day ${homeData?.user!.streak!.days ?? 0}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            homeData?.user!.streak!.icon ?? '🔥',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
