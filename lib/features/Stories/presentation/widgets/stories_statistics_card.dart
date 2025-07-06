import 'package:flutter/material.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';
import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';

class StoriesStatisticsCard extends StatefulWidget {
  final List<Stories> stories;

  const StoriesStatisticsCard({
    super.key,
    required this.stories,
  });

  @override
  State<StoriesStatisticsCard> createState() => _StoriesStatisticsCardState();
}

class _StoriesStatisticsCardState extends State<StoriesStatisticsCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for each stat
    _animations = List.generate(
      4,
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.2,
            (index * 0.2) + 0.6,
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStatistics();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primaryColor,
            ColorManager.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'إحصائيات القصص',
                style: getBoldStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Statistics Grid
          Column(
            children: [
              // First Row
              Row(
                children: [
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _animations[0],
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animations[0].value,
                          child: _buildStatItem(
                            'الإجمالي',
                            stats['total'].toString(),
                            Icons.library_books_rounded,
                            Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _animations[1],
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animations[1].value,
                          child: _buildStatItem(
                            'للأولاد',
                            stats['boys'].toString(),
                            Icons.boy_rounded,
                            Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 16),
                color: Colors.white.withOpacity(0.3),
              ),

              // Second Row
              Row(
                children: [
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _animations[2],
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animations[2].value,
                          child: _buildStatItem(
                            'للبنات',
                            stats['girls'].toString(),
                            Icons.girl_rounded,
                            Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _animations[3],
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animations[3].value,
                          child: _buildStatItem(
                            'كلاهما',
                            stats['both'].toString(),
                            Icons.groups_rounded,
                            Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Additional Statistics
          _buildAdditionalStats(stats),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color.withOpacity(0.8),
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: getBoldStyle(
            color: color,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: getRegularStyle(
            color: color.withOpacity(0.9),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAdditionalStats(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات إضافية',
            style: getMediumStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          // Age Groups
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: stats['ageGroups'].map<Widget>((ageGroup) {
              final count = widget.stories
                  .where((story) => story.ageGroup == ageGroup)
                  .length;
              return _buildMiniStat('$ageGroup سنة', count.toString());
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Best Friend Stats
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  'صديق ولد',
                  stats['maleFriends'].toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniStat(
                  'صديق بنت',
                  stats['femaleFriends'].toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: getBoldStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: getRegularStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateStatistics() {
    final total = widget.stories.length;
    final boys = widget.stories.where((story) => story.gender == 'Boy').length;
    final girls = widget.stories.where((story) => story.gender == 'Girl').length;
    final both = widget.stories.where((story) => story.gender == 'Both').length;
    final maleFriends = widget.stories
        .where((story) => story.bestFriendGender == 'Male')
        .length;
    final femaleFriends = widget.stories
        .where((story) => story.bestFriendGender == 'Female')
        .length;

    // Get unique age groups
    final ageGroups = widget.stories
        .map((story) => story.ageGroup)
        .where((age) => age != null)
        .toSet()
        .toList();

    return {
      'total': total,
      'boys': boys,
      'girls': girls,
      'both': both,
      'maleFriends': maleFriends,
      'femaleFriends': femaleFriends,
      'ageGroups': ageGroups,
    };
  }
}