import 'package:flutter/material.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';

class StoriesFilterBar extends StatefulWidget {
  final Function(String) onGenderFilter;
  final Function(String) onAgeFilter;
  final Function(String) onBestFriendFilter;
  final VoidCallback onClearFilters;

  const StoriesFilterBar({
    super.key,
    required this.onGenderFilter,
    required this.onAgeFilter,
    required this.onBestFriendFilter,
    required this.onClearFilters,
  });

  @override
  State<StoriesFilterBar> createState() => _StoriesFilterBarState();
}

class _StoriesFilterBarState extends State<StoriesFilterBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  String _selectedGender = 'all';
  String _selectedAge = 'all';
  String _selectedBestFriend = 'all';

  final List<Map<String, dynamic>> _genderOptions = [
    {'value': 'all', 'label': 'الكل', 'icon': Icons.groups_rounded},
    {'value': 'Boy', 'label': 'أولاد', 'icon': Icons.boy_rounded},
    {'value': 'Girl', 'label': 'بنات', 'icon': Icons.girl_rounded},
    {'value': 'Both', 'label': 'كلاهما', 'icon': Icons.people_rounded},
  ];

  final List<Map<String, dynamic>> _ageOptions = [
    {'value': 'all', 'label': 'جميع الأعمار', 'icon': Icons.cake_rounded},
    {'value': '2-4', 'label': '2-4 سنوات', 'icon': Icons.child_care_rounded},
    {'value': '5-8', 'label': '5-8 سنوات', 'icon': Icons.school_rounded},
    {'value': '9-12', 'label': '9-12 سنة', 'icon': Icons.sports_esports_rounded},
  ];

  final List<Map<String, dynamic>> _bestFriendOptions = [
    {'value': 'all', 'label': 'أي صديق', 'icon': Icons.favorite_rounded},
    {'value': 'Male', 'label': 'صديق ولد', 'icon': Icons.boy_rounded},
    {'value': 'Female', 'label': 'صديق بنت', 'icon': Icons.girl_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
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
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(_slideAnimation),
      child: FadeTransition(
        opacity: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: ColorManager.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'تصفية القصص',
                    style: getBoldStyle(
                      color: ColorManager.titleColor,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _clearAllFilters,
                    icon: Icon(
                      Icons.clear_all_rounded,
                      size: 16,
                      color: Colors.red[600],
                    ),
                    label: Text(
                      'مسح الكل',
                      style: getMediumStyle(
                        color: Colors.red[600],
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      backgroundColor: Colors.red.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Gender Filter
              _buildFilterSection(
                title: 'الجنس',
                options: _genderOptions,
                selectedValue: _selectedGender,
                onChanged: (value) {
                  setState(() => _selectedGender = value);
                  widget.onGenderFilter(value);
                },
              ),

              const SizedBox(height: 20),

              // Age Filter
              _buildFilterSection(
                title: 'الفئة العمرية',
                options: _ageOptions,
                selectedValue: _selectedAge,
                onChanged: (value) {
                  setState(() => _selectedAge = value);
                  widget.onAgeFilter(value);
                },
              ),

              const SizedBox(height: 20),

              // Best Friend Filter
              _buildFilterSection(
                title: 'الصديق المفضل',
                options: _bestFriendOptions,
                selectedValue: _selectedBestFriend,
                onChanged: (value) {
                  setState(() => _selectedBestFriend = value);
                  widget.onBestFriendFilter(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<Map<String, dynamic>> options,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getMediumStyle(
            color: ColorManager.titleColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option['value'];
            return _buildFilterChip(
              label: option['label'],
              icon: option['icon'],
              isSelected: isSelected,
              onTap: () => onChanged(option['value']),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorManager.primaryColor
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? ColorManager.primaryColor
                    : Colors.grey[300]!,
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: ColorManager.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: getMediumStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedGender = 'all';
      _selectedAge = 'all';
      _selectedBestFriend = 'all';
    });
    widget.onClearFilters();
  }
}