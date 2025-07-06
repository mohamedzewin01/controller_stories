import 'package:flutter/material.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';
import 'package:controller_stories/core/resources/cashed_image.dart';
import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';

class StoryDetailsSheet extends StatefulWidget {
  final Stories story;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StoryDetailsSheet({
    super.key,
    required this.story,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<StoryDetailsSheet> createState() => _StoryDetailsSheetState();
}

class _StoryDetailsSheetState extends State<StoryDetailsSheet>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Story Image
                      _buildStoryImage(),

                      const SizedBox(height: 24),

                      // Story Details
                      _buildStoryDetails(),

                      const SizedBox(height: 24),

                      // Problem Details
                      _buildProblemDetails(),

                      const SizedBox(height: 24),

                      // Target Audience
                      _buildTargetAudience(),

                      const SizedBox(height: 24),

                      // Additional Info
                      _buildAdditionalInfo(),

                      const SizedBox(height: 100), // Space for floating buttons
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: getGenderColor(widget.story.gender ?? 'Boy').withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: getGenderColor(widget.story.gender ?? 'Boy'),
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.story.storyTitle ?? 'بدون عنوان',
                  style: getBoldStyle(
                    color: ColorManager.titleColor,
                    fontSize: 20,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  'تفاصيل القصة',
                  style: getRegularStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: widget.story.imageCover != null && widget.story.imageCover!.isNotEmpty
            ? Hero(
          tag: 'story_image_${widget.story.storyId}',
          child: CustomImage(
            url: widget.story.imageCover!,
            width: double.infinity,
            height: 250,
            boxFit: BoxFit.cover,
          ),
        )
            : Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_rounded,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'لا توجد صورة غلاف',
                style: getMediumStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryDetails() {
    return _buildSection(
      title: 'تفاصيل القصة',
      icon: Icons.description_rounded,
      color: Colors.blue[600]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'العنوان',
            widget.story.storyTitle ?? 'غير محدد',
            Icons.title_rounded,
          ),

          const SizedBox(height: 16),

          _buildDetailRow(
            'الوصف',
            widget.story.storyDescription ?? 'لا يوجد وصف',
            Icons.text_snippet_rounded,
            isLongText: true,
          ),

          const SizedBox(height: 16),

          _buildDetailRow(
            'تاريخ الإنشاء',
            _formatDateTime(widget.story.createdAt),
            Icons.calendar_today_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildProblemDetails() {
    return _buildSection(
      title: 'تفاصيل المشكلة',
      icon: Icons.psychology_rounded,
      color: Colors.orange[600]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'رقم المشكلة',
            widget.story.problemId?.toString() ?? 'غير محدد',
            Icons.numbers_rounded,
          ),

          const SizedBox(height: 16),

          _buildDetailRow(
            'عنوان المشكلة',
            widget.story.problemTitle ?? 'غير محدد',
            Icons.title_rounded,
          ),

          if (widget.story.problemDescription != null) ...[
            const SizedBox(height: 16),
            _buildDetailRow(
              'وصف المشكلة',
              widget.story.problemDescription!,
              Icons.text_snippet_rounded,
              isLongText: true,
            ),
          ],

          if (widget.story.problemCreatedAt != null) ...[
            const SizedBox(height: 16),
            _buildDetailRow(
              'تاريخ إنشاء المشكلة',
              _formatDateTime(widget.story.problemCreatedAt),
              Icons.schedule_rounded,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTargetAudience() {
    return _buildSection(
      title: 'الجمهور المستهدف',
      icon: Icons.people_rounded,
      color: Colors.purple[600]!,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'الجنس',
                  getGenderText(widget.story.gender ?? 'Boy'),
                  Icons.person_rounded,
                  getGenderColor(widget.story.gender ?? 'Boy'),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _buildInfoCard(
                  'الفئة العمرية',
                  '${widget.story.ageGroup ?? 'غير محدد'} سنة',
                  Icons.cake_rounded,
                  Colors.green[600]!,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoCard(
            'الصديق المفضل',
            getGenderBestFriendText(widget.story.bestFriendGender ?? 'Male'),
            Icons.favorite_rounded,
            getBestFriendColor(widget.story.bestFriendGender ?? 'Male'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return _buildSection(
      title: 'معلومات إضافية',
      icon: Icons.info_rounded,
      color: Colors.teal[600]!,
      child: Column(
        children: [
          _buildDetailRow(
            'معرف القصة',
            widget.story.storyId?.toString() ?? 'غير محدد',
            Icons.fingerprint_rounded,
          ),

          const SizedBox(height: 16),

          _buildDetailRow(
            'معرف الفئة',
            widget.story.categoryId?.toString() ?? 'غير محدد',
            Icons.category_rounded,
          ),

          if (widget.story.problemCategoryId != null) ...[
            const SizedBox(height: 16),
            _buildDetailRow(
              'معرف فئة المشكلة',
              widget.story.problemCategoryId!.toString(),
              Icons.category_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),

              const SizedBox(width: 12),

              Text(
                title,
                style: getBoldStyle(
                  color: ColorManager.titleColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      String label,
      String value,
      IconData icon, {
        bool isLongText = false,
      }) {
    return Row(
      crossAxisAlignment: isLongText ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),

        const SizedBox(width: 8),

        SizedBox(
          width: 80,
          child: Text(
            label,
            style: getMediumStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Text(
              value,
              style: getRegularStyle(
                color: ColorManager.titleColor,
                fontSize: 14,
              ),
              maxLines: isLongText ? null : 1,
              overflow: isLongText ? null : TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String label,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: getMediumStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: getBoldStyle(
              color: color,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String? dateString) {
    if (dateString == null) return 'غير محدد';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'تاريخ غير صحيح';
    }
  }
}

// Helper functions (same as in StoryCard)
String getGenderText(String gender) {
  switch (gender) {
    case 'Boy':
      return 'ولد';
    case 'Girl':
      return 'بنت';
    case 'Both':
      return 'كلاهما';
    default:
      return 'غير محدد';
  }
}

String getGenderBestFriendText(String gender) {
  switch (gender) {
    case 'Male':
      return 'ولد';
    case 'Female':
      return 'بنت';
    default:
      return 'غير محدد';
  }
}

Color getGenderColor(String gender) {
  switch (gender) {
    case 'Boy':
      return Colors.blue;
    case 'Girl':
      return Colors.pink;
    case 'Both':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}

Color getBestFriendColor(String gender) {
  switch (gender) {
    case 'Male':
      return Colors.blue;
    case 'Female':
      return Colors.pink;
    default:
      return Colors.grey;
  }
}