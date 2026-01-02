import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tutor_app/features/streaks/controllers/streaks_controller.dart';
import 'package:tutor_app/features/streaks/widgets/streak_path_painter.dart';
import 'package:tutor_app/utils/const/app_colors.dart';

class StreaksScreen extends StatefulWidget {
  const StreaksScreen({super.key});

  @override
  State<StreaksScreen> createState() => _StreaksScreenState();
}

class _StreaksScreenState extends State<StreaksScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasInitialScrolled = false;
  
  // Track which day is currently selected for showing tooltip
  final RxInt selectedDayIndex = (-1).obs;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StreaksController>();

    return Scaffold(
      backgroundColor: const Color(0xFFC7F3F6), // Light blue-teal from design
      body: Obx(() {
        if (controller.isLoading.value) {
          // Reset scroll flag on loading
          _hasInitialScrolled = false;
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4CA6A8)),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                TextButton(
                  onPressed: controller.retry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final data = controller.streakData.value;
        if (data == null || data.days == null || data.days!.isEmpty) {
          return const Center(child: Text('No streak data available'));
        }

        final days = data.days!;
        final totalDays = days.length;
        const nodeSpacing = 140.0;
        final totalHeight = totalDays * nodeSpacing + 200; // Extra padding

        // Auto-scroll logic
        if (!_hasInitialScrolled) {
          final currentIndex = days.indexWhere((d) => d.isCurrent == true);
          if (currentIndex != -1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                try {
                  final viewportHeight =
                      _scrollController.position.viewportDimension;
                  final maxScroll = _scrollController.position.maxScrollExtent;

                  // Calculate target offset
                  final bottomOffset = 100.0 + (currentIndex * nodeSpacing);
                  final nodeCenterFromTop = totalHeight - (bottomOffset + 30);
                  final targetOffset = nodeCenterFromTop - (viewportHeight / 2);

                  // Clamp
                  final clampedOffset = targetOffset.clamp(0.0, maxScroll);

                  _scrollController.animateTo(
                    clampedOffset,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                  );
                } catch (e) {
                  // Safety for scroll calculation errors
                }
              }
            });
            _hasInitialScrolled = true;
          }
        }

        return Stack(
          children: [
            // Background Assets
            Positioned(
              left: -20,
              top: 100,
              child: Opacity(
                opacity: 0.6,
                child: SvgPicture.asset(
                  'assets/svg/star.svg',
                  width: 40,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 250,
              child: Opacity(
                opacity: 0.6,
                child: SvgPicture.asset(
                  'assets/svg/star.svg',
                  width: 50,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            Positioned(
              left: 40,
              bottom: 100,
              child: Opacity(
                opacity: 0.2,
                child: SvgPicture.asset(
                  'assets/svg/flower.svg',
                  width: 60,
                  color: AppColors.primaryDark,
                ),
              ),
            ),

            // Scrollable Path
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: totalHeight,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // The Path Line
                      CustomPaint(
                        size: Size(double.infinity, totalHeight),
                        painter: StreakPathPainter(
                          totalNodes: totalDays,
                          nodeSpacing: nodeSpacing,
                          amplitude: 100.0,
                        ),
                      ),

                      // The Nodes
                      ...List.generate(totalDays, (index) {
                        final day = days[index];
                        final bottomOffset = 100.0 + (index * nodeSpacing);

                        final centerX = MediaQuery.of(context).size.width / 2;
                        final xOffset = 100.0 * sin(index * pi / 1.8);
                        
                        // Check if this node is selected
                        final isSelected = selectedDayIndex.value == index;

                        return Positioned(
                          bottom: bottomOffset,
                          left: centerX + xOffset - 40, // 40 is half of width(80)
                          child: Obx(() {
                            final showTooltip = selectedDayIndex.value == index;
                            
                            return Row(
                              children: [
                                // Tooltip Left (only show when selected)
                                if (showTooltip && xOffset > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: TopicTooltipWidget(
                                      title: day.topic?.title ?? 'Topic',
                                      modules:
                                          day.topic?.modules
                                              ?.map(
                                                (m) => m.name
                                                    .toString()
                                                    .replaceAll(
                                                      'Description.',
                                                      '',
                                                    )
                                                    .replaceAll('_', ' '),
                                              )
                                              .toList() ??
                                          [],
                                      onClose: () {
                                        selectedDayIndex.value = -1;
                                      },
                                    ),
                                  ),

                                // Node + Fire Icon
                                Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: DayNodeWidget(
                                        dayNumber: day.dayNumber ?? (index + 1),
                                        isCompleted: day.isCompleted ?? false,
                                        isCurrent: day.isCurrent ?? false,
                                        isSelected: isSelected,
                                        onTap: () {
                                          // Toggle selection
                                          if (selectedDayIndex.value == index) {
                                            selectedDayIndex.value = -1;
                                          } else {
                                            selectedDayIndex.value = index;
                                          }
                                        },
                                      ),
                                    ),
                                    if (day.isCurrent == true)
                                      Positioned(
                                        top: 0,
                                        child: SvgPicture.asset(
                                          'assets/svg/fire.svg',
                                          height: 24,
                                        ),
                                      ),
                                  ],
                                ),

                                // Tooltip Right (only show when selected)
                                if (showTooltip && xOffset <= 0)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TopicTooltipWidget(
                                      title: day.topic?.title ?? 'Topic',
                                      modules:
                                          day.topic?.modules
                                              ?.map(
                                                (m) => m.name
                                                    .toString()
                                                    .replaceAll(
                                                      'Description.',
                                                      '',
                                                    )
                                                    .replaceAll('_', ' '),
                                              )
                                              .toList() ??
                                          [],
                                      onClose: () {
                                        selectedDayIndex.value = -1;
                                      },
                                    ),
                                  ),
                              ],
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: 50,
              left: 16,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.teal),
                  onPressed: () {
                    selectedDayIndex.value = -1;
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Updated DayNodeWidget with isSelected state
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

// Updated TopicTooltipWidget with close button
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