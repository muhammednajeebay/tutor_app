import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/data/models/home_model.dart';
import 'package:tutor_app/utils/const/app_colors.dart';

class CommunityCard extends StatelessWidget {
  final Community community;

  const CommunityCard({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.people, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      community.name ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${community.activeMembers ?? 0} active members',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            community.description ?? '',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFE3F2FD),
              padding: const EdgeInsets.symmetric(
                // horizontal: 32,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                community.action ?? 'Join Discussion',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Member avatars
              if (community.recentActivity?.recentMembers != null)
                ...List.generate(
                  community.recentActivity!.recentMembers!.length.clamp(0, 3),
                  (index) {
                    final member =
                        community.recentActivity!.recentMembers![index];
                    return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: member.avatar != null
                            ? CachedNetworkImageProvider(member.avatar!)
                            : null,
                        backgroundColor: AppColors.grey300,
                        child: member.avatar == null
                            ? const Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              const SizedBox(width: 12),
              Text(
                '${community.recentActivity?.recentPosts ?? 0} recent posts',
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
              const Spacer(),
              Text(
                community.recentActivity?.status ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
