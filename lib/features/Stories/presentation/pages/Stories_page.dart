import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';
import 'package:controller_stories/core/widgets/custom_app_bar.dart';
import 'package:controller_stories/core/widgets/custom_text_form.dart';
import 'package:controller_stories/core/widgets/custom_snack_bar.dart';
import 'package:controller_stories/core/widgets/custom_dialog.dart';
import 'package:controller_stories/core/resources/cashed_image.dart';
import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';
import 'package:controller_stories/l10n/app_localizations.dart';
import '../../../../core/di/di.dart';
import '../bloc/Stories_cubit.dart';

class StoriesPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const StoriesPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage>
    with TickerProviderStateMixin {
  late StoriesCubit viewModel;
  late AnimationController _fabController;
  late AnimationController _listController;
  late Animation<double> _fabAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<StoriesCubit>();

    // إعداد الأنيميشن
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _listController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _listController, curve: Curves.easeOutCubic),
        );

    // تحميل البيانات
    _loadStories();

    // بدء الأنيميشن
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fabController.forward();
        _listController.forward();
      }
    });
  }

  void _loadStories() {
    print('Loading stories for category: ${widget.categoryId}');
    viewModel.fetchStoriesByCategory(widget.categoryId);
  }

  @override
  void dispose() {
    _fabController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: ColorManager.appBackground,
        body: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: ColorManager.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorManager.primaryColor,
                        ColorManager.primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.auto_stories_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.categoryName,
                                  style: getBoldStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اكتشف القصص المثيرة والتعليمية',
                            style: getRegularStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stories List
                    BlocConsumer<StoriesCubit, StoriesState>(
                      listener: (context, state) {
                        print(
                          'BlocConsumer listener - State: ${state.runtimeType}',
                        );

                        if (state is StoriesFailure) {
                          print('Stories Error: ${state.exception}');
                          CustomSnackBar.showErrorSnackBar(
                            context,
                            message: 'حدث خطأ: ${state.exception.toString()}',
                          );
                        } else if (state is StoriesAddSuccess) {
                          CustomSnackBar.showSuccessSnackBar(
                            context,
                            message: 'تم إضافة القصة بنجاح',
                          );
                          _loadStories(); // إعادة تحميل القصص بعد الإضافة
                        } else if (state is StoriesDeleteSuccess) {
                          CustomSnackBar.showSuccessSnackBar(
                            context,
                            message: 'تم حذف القصة بنجاح',
                          );
                          _loadStories(); // إعادة تحميل القصص بعد الحذف
                        }
                      },
                      builder: (context, state) {
                        print(
                          'BlocConsumer builder - State: ${state.runtimeType}',
                        );

                        if (state is StoriesLoading) {
                          return _buildLoadingState();
                        }

                        // تحسين التعامل مع حالات النجاح
                        if (state is StoriesSuccess) {
                          print('Stories loaded successfully');
                          return _buildStoriesList(state.fetchStoriesEntity);
                        }

                        if (state is StoriesSearchResult) {
                          return _buildStoriesList(state.searchResult);
                        }

                        if (state is StoriesFilterByGenderResult) {
                          return _buildStoriesList(state.filterResult);
                        }

                        if (state is StoriesFilterByAgeResult) {
                          return _buildStoriesList(state.filterResult);
                        }

                        if (state is StoriesFailure) {
                          return _buildErrorState();
                        }

                        // الحالة الافتراضية
                        return _buildEmptyState();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Floating Action Button
        floatingActionButton: ScaleTransition(
          scale: _fabAnimation,
          child: FloatingActionButton.extended(
            onPressed: () => _showAddStoryDialog(),
            backgroundColor: ColorManager.primaryColor,
            foregroundColor: Colors.white,
            elevation: 8,
            icon: const Icon(Icons.add_rounded, size: 24),
            label: Text(
              'إضافة قصة',
              style: getBoldStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(4, (index) => _buildLoadingShimmer()),
    );
  }

  Widget _buildLoadingShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(dynamic storiesEntity) {
    print('Building stories list. Entity: $storiesEntity');

    // التحقق من وجود البيانات بطريقة أفضل
    List<Stories>? stories;

    try {
      if (storiesEntity != null) {
        if (storiesEntity.stories != null) {
          stories = storiesEntity.stories as List<Stories>?;
        } else {
          stories = storiesEntity as List<Stories>?;
        }
      }
    } catch (e) {
      print('Error parsing stories: $e');
      return _buildErrorState();
    }

    print('Stories count: ${stories?.length ?? 0}');

    if (stories == null || stories.isEmpty) {
      return _buildEmptyState();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          // Statistics Card
          _buildStatisticsCard(stories),
          const SizedBox(height: 20),

          // Stories List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return _buildStoryCard(stories![index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(List<Stories> stories) {
    // حساب الإحصائيات بناءً على البيانات الفعلية
    int maleStories = stories.where((story) => story.gender == 'Boy').length;
    int femaleStories = stories.where((story) => story.gender == 'Girl').length;
    int otherStories = stories.where((story) => story.gender == 'Both').length;

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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('الإجمالي', stories.length.toString()),
          ),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
          Expanded(child: _buildStatItem('للأولاد', maleStories.toString())),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
          Expanded(child: _buildStatItem('للبنات', femaleStories.toString())),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
          Expanded(child: _buildStatItem('كلاهما', otherStories.toString())),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: getBoldStyle(color: Colors.white, fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          style: getRegularStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStoryCard(Stories story, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // يمكن إضافة navigation هنا لاحقاً
                  print('Story tapped: ${story.storyTitle}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Story Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child:
                              story.imageCover != null &&
                                  story.imageCover!.isNotEmpty
                              ? CustomImage(
                                  url: story.imageCover!,
                                  width: 80,
                                  height: 80,
                                  boxFit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.image_rounded,
                                  color: Colors.grey[400],
                                  size: 32,
                                ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Story Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              story.storyTitle ?? 'بدون عنوان',
                              style: getBoldStyle(
                                color: ColorManager.titleColor,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            // Description
                            Text(
                              story.storyDescription ?? 'لا يوجد وصف',
                              style: getRegularStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            // Tags Row
                            Column(
                              children: [
                                Row(
                                  children: [
                                    _buildTag(
                                      // story.gender == 'Boy' ? 'ولد' : 'بنت',
                                      getGenderText(story.gender ?? 'Boy'),
                                      getGenderColor(story.gender ?? 'Boy'),
                                      // story.gender == 'Girl' ? Colors.blue : Colors.pink,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildTag(
                                      story.ageGroup ?? 'غير محدد',
                                      Colors.green.shade600,
                                    ),

                                    const Spacer(),
                                    Text(
                                      _formatDate(story.createdAt),
                                      style: getRegularStyle(
                                        color: Colors.grey[500],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildTag(
                                      getGenderBestFriendText(story.bestFriendGender??"Male"),
                                        getBestFriendColor(story.bestFriendGender??"Male")
                                    ),
                                    SizedBox(width: 8),
                                    Text('صديق المفضل',style: getMediumStyle(fontSize: 12,color: Colors.blueAccent),),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Action Menu
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _showEditStoryDialog(story);
                              break;
                            case 'delete':
                              _showDeleteConfirmation(story);
                              break;
                            case 'details':
                              // يمكن إضافة navigation للتفاصيل هنا
                              print('Show details for: ${story.storyTitle}');
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'details',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_rounded,
                                  size: 18,
                                  color: Colors.blue[600],
                                ),
                                const SizedBox(width: 8),
                                const Text('التفاصيل'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  size: 18,
                                  color: Colors.orange[600],
                                ),
                                const SizedBox(width: 8),
                                const Text('تعديل'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_rounded,
                                  size: 18,
                                  color: Colors.red[600],
                                ),
                                const SizedBox(width: 8),
                                const Text('حذف'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: getBoldStyle(color: color, fontSize: 10)),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_outlined,
              size: 64,
              color: ColorManager.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد قصص في هذه الفئة بعد',
            style: getBoldStyle(color: ColorManager.titleColor, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإضافة قصة جديدة لإثراء المحتوى',
            style: getRegularStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddStoryDialog(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('إضافة قصة جديدة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في تحميل البيانات',
            style: getBoldStyle(color: ColorManager.titleColor, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'تحقق من اتصال الإنترنت أو حاول مرة أخرى',
            style: getRegularStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _loadStories(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Methods
  void _showAddStoryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StoryFormDialog(
        categoryId: widget.categoryId,
        onSave:
            (
              title,
              description,
              problemId,
              gender,
              ageGroup,
              imageCover,
              bestFriendGender,
            ) async {
              Navigator.pop(context);
              await viewModel.addStory(
                title: title,
                storyDescription: description,
                problemId: problemId,
                gender: gender,
                ageGroup: ageGroup,
                categoryId: widget.categoryId,
                isActive: true,
                imageCover: imageCover,
                bestFriendGender: bestFriendGender,
              );
            },
      ),
    );
  }

  void _showEditStoryDialog(Stories story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StoryFormDialog(
        story: story,
        categoryId: widget.categoryId,
        onSave:
            (
              title,
              description,
              problemId,
              gender,
              ageGroup,
              imageCover,
              bestFriendGender,
            ) async {
              Navigator.pop(context);
              // TODO: Implement update story when API is available

              CustomSnackBar.showInfoSnackBar(
                context,
                message: 'تعديل القصص سيتم إضافته قريباً',
              );
            },
      ),
    );
  }

  void _showDeleteConfirmation(Stories story) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[600]),
            const SizedBox(width: 8),
            Text(
              'حذف القصة',
              style: getBoldStyle(color: ColorManager.titleColor, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل أنت متأكد من حذف قصة "${story.storyTitle}"؟',
              style: getRegularStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red[600], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'سيتم حذف القصة نهائياً ولا يمكن استرجاعها',
                      style: getRegularStyle(
                        color: Colors.red[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await viewModel.deleteStory(story.storyId!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }


}

// Story Form Dialog
class StoryFormDialog extends StatefulWidget {
  final Stories? story;
  final int categoryId;
  final Function(
    String title,
    String description,
    int problemId,
    String gender,
    String ageGroup,
    File imageCover,
    String? bestFriendGender,
  )
  onSave;

  const StoryFormDialog({
    super.key,
    this.story,
    required this.categoryId,
    required this.onSave,
  });

  @override
  State<StoryFormDialog> createState() => _StoryFormDialogState();
}

class _StoryFormDialogState extends State<StoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _problemIdController = TextEditingController();

  String _selectedGender = 'Boy';
  String _bestFriendGender = 'Male';
  String _selectedAgeGroup = '2-4';
  File? _selectedImage;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Boy', 'Girl', 'Both'];
  final List<String> _bestFriendOptions = ['Male', 'Female'];
  final List<String> _ageGroupOptions = ['2-4', '5-8', '9-12'];

  @override
  void initState() {
    super.initState();
    if (widget.story != null) {
      _titleController.text = widget.story!.storyTitle ?? '';
      _descriptionController.text = widget.story!.storyDescription ?? '';
      _problemIdController.text = widget.story!.problemId?.toString() ?? '';
      _selectedGender = widget.story!.gender ?? 'Boy';
      _bestFriendGender = widget.story!.bestFriendGender ?? 'Male';
      _selectedAgeGroup = widget.story!.ageGroup ?? '2-4';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.story == null
                            ? Icons.add_rounded
                            : Icons.edit_rounded,
                        color: ColorManager.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.story == null
                            ? 'إضافة قصة جديدة'
                            : 'تعديل القصة',
                        style: getBoldStyle(
                          color: ColorManager.titleColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Image Picker
                _buildImagePicker(),

                const SizedBox(height: 20),

                // Form Fields
                CustomTextFormNew(
                  title: 'عنوان القصة',
                  hintText: 'أدخل عنوان القصة',
                  controller: _titleController,
                  prefixIcon: Icons.title_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال عنوان القصة';
                    }
                    return null;
                  },
                ),

                CustomTextFormNew(
                  title: 'وصف القصة',
                  hintText: 'أدخل وصف القصة',
                  controller: _descriptionController,
                  prefixIcon: Icons.description_rounded,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال وصف القصة';
                    }
                    return null;
                  },
                ),

                CustomTextFormNew(
                  title: 'رقم المشكلة',
                  hintText: 'أدخل رقم المشكلة',
                  controller: _problemIdController,
                  prefixIcon: Icons.error,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال رقم المشكلة';
                    }
                    if (int.tryParse(value) == null) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),

                // Gender Selection
                const SizedBox(height: 16),
                Text(
                  'الجنس المستهدف',
                  style: getMediumStyle(
                    color: ColorManager.titleColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _genderOptions.map((gender) {
                    final isSelected = _selectedGender == gender;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = gender),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorManager.primaryColor
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? ColorManager.primaryColor
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            getGenderText(gender),
                            style: getBoldStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Age Group Selection
                const SizedBox(height: 16),
                Text(
                  'الفئة العمرية',
                  style: getMediumStyle(
                    color: ColorManager.titleColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _ageGroupOptions.map((ageGroup) {
                    final isSelected = _selectedAgeGroup == ageGroup;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedAgeGroup = ageGroup),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorManager.primaryColor
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? ColorManager.primaryColor
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            '$ageGroup سنة',
                            style: getBoldStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'الصديق المفضل',
                  style: getMediumStyle(
                    color: ColorManager.titleColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: _bestFriendOptions.map((bestFriend) {
                    final isSelected = _bestFriendGender == bestFriend;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _bestFriendGender = bestFriend),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorManager.primaryColor
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? ColorManager.primaryColor
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            getGenderBestFriendText(bestFriend),
                            style: getBoldStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('حفظ'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: _selectedImage != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedImage = null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 48,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط لإضافة صورة الغلاف',
                    style: getMediumStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _pickImage() async {
    await CustomDialog.showDialogAddImage(
      context,
      gallery: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (pickedFile != null) {
          setState(() => _selectedImage = File(pickedFile.path));
        }
      },
      camera: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (pickedFile != null) {
          setState(() => _selectedImage = File(pickedFile.path));
        }
      },
    );
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null && widget.story == null) {
        CustomSnackBar.showErrorSnackBar(
          context,
          message: 'يرجى اختيار صورة الغلاف',
        );
        return;
      }

      setState(() => _isLoading = true);

      HapticFeedback.mediumImpact();

      try {
        await widget.onSave(
          _titleController.text.trim(),
          _descriptionController.text.trim(),
          int.parse(_problemIdController.text.trim()),
          _selectedGender,
          _selectedAgeGroup,
          _selectedImage ?? File(''),
          _bestFriendGender, // For edit mode, API should handle null image
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _problemIdController.dispose();
    super.dispose();
  }
}

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