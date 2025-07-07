import 'package:controller_stories/features/Clips/presentation/pages/Clips_page.dart';
import 'package:controller_stories/features/Problems/presentation/bloc/Problems_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';
import 'package:controller_stories/core/widgets/custom_snack_bar.dart';
import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';
import 'package:controller_stories/features/Stories/presentation/widgets/story_card.dart';
import 'package:controller_stories/features/Stories/presentation/widgets/story_details_sheet.dart';
import 'package:controller_stories/features/Stories/presentation/widgets/story_form_dialog.dart';
import 'package:controller_stories/features/Stories/presentation/widgets/stories_statistics_card.dart';

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
  late ProblemsCubit problemsCubit;
  late AnimationController _fabController;
  late AnimationController _listController;
  late Animation<double> _fabAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<StoriesCubit>();
    problemsCubit = getIt.get<ProblemsCubit>();
    // Setup animations
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

    // Load stories
    _loadStories();

    // Start animations
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: viewModel),
        BlocProvider.value(value: problemsCubit),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.appBackground,
        body: CustomScrollView(
          slivers: [
            // Custom App Bar
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16,
                ),
                child: BlocConsumer<StoriesCubit, StoriesState>(
                  listener: _handleStateChanges,
                  builder: _buildContent,
                ),
              ),
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: 150)),
          ],
        ),

        // Floating Action Buttons
        floatingActionButton: _buildFloatingActionButtons(),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
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
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Refresh button
        ScaleTransition(
          scale: _fabAnimation,
          child: FloatingActionButton(
            onPressed: _loadStories,
            backgroundColor: Colors.white,
            foregroundColor: ColorManager.primaryColor,
            elevation: 4,
            heroTag: "refresh",
            child: const Icon(Icons.refresh_rounded),
          ),
        ),

        const SizedBox(height: 16),

        // Add story button
        ScaleTransition(
          scale: _fabAnimation,
          child: FloatingActionButton.extended(
            onPressed: () => _showAddStoryDialog(context),
            backgroundColor: ColorManager.primaryColor,
            foregroundColor: Colors.white,
            elevation: 8,
            heroTag: "add",
            icon: const Icon(Icons.add_rounded, size: 24),
            label: Text(
              'إضافة قصة',
              style: getBoldStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddStoryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: viewModel),
          BlocProvider.value(value: problemsCubit),
        ],
        child: StoryFormDialog(
          categoryId: widget.categoryId, // Replace with actual category ID
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
                // Handle story creation
                await viewModel.addStory(
                  title: title,
                  storyDescription: description,
                  problemId: problemId,
                  gender: gender,
                  ageGroup: ageGroup,
                  categoryId: widget.categoryId,
                  isActive: true,
                  imageCover: imageCover,
                  bestFriendGender:
                      bestFriendGender, // Replace with actual category ID
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
        ),
      ),
    );
  }

  // void _showAddStoryDialog() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => StoryFormDialog(
  //       categoryId: widget.categoryId,
  //       onSave: (title, description, problemId, gender, ageGroup, imageCover, bestFriendGender) async {
  //         Navigator.pop(context);
  //         await viewModel.addStory(
  //           title: title,
  //           storyDescription: description,
  //           problemId: problemId,
  //           gender: gender,
  //           ageGroup: ageGroup,
  //           categoryId: widget.categoryId,
  //           isActive: true,
  //           imageCover: imageCover,
  //           bestFriendGender: bestFriendGender,
  //         );
  //       },
  //     ),
  //   );
  // }
  void _handleStateChanges(BuildContext context, StoriesState state) {
    print('BlocConsumer listener - State: ${state.runtimeType}');

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
    } else if (state is StoriesUpdateSuccess) {
      CustomSnackBar.showSuccessSnackBar(
        context,
        message: 'تم تحديث القصة بنجاح',
      );
    } else if (state is StoriesDeleteSuccess) {
      CustomSnackBar.showSuccessSnackBar(
        context,
        message: 'تم حذف القصة بنجاح',
      );
    }
  }

  Widget _buildContent(BuildContext context, StoriesState state) {
    print('BlocConsumer builder - State: ${state.runtimeType}');

    if (state is StoriesLoading) {
      return _buildLoadingState();
    }

    // Handle different success states
    dynamic storiesEntity;
    if (state is StoriesSuccess) {
      storiesEntity = state.fetchStoriesEntity;
    } else if (state is StoriesSearchResult) {
      storiesEntity = state.searchResult;
    } else if (state is StoriesFilterByGenderResult) {
      storiesEntity = state.filterResult;
    } else if (state is StoriesFilterByAgeResult) {
      storiesEntity = state.filterResult;
    } else if (state is StoriesFilterByBestFriendResult) {
      storiesEntity = state.filterResult;
    }

    if (storiesEntity != null) {
      return _buildStoriesList(storiesEntity);
    }

    if (state is StoriesFailure) {
      return _buildErrorState();
    }

    // Default state
    return _buildEmptyState();
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
            onPressed: () => _showAddStoryDialog(context),
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

    List<Stories>? stories;
    try {
      if (storiesEntity != null) {
        stories = storiesEntity.stories as List<Stories>?;
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
          StoriesStatisticsCard(stories: stories),

          const SizedBox(height: 20),

          // Stories List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return StoryCard(
                story: stories![index],
                index: index,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClipsPage(
                        storyId: stories?[index].storyId ?? 0,
                        storyTitle: stories?[index].storyTitle ?? '',
                      ),
                    ),
                  );
                },
                onEdit: () => _showEditStoryDialog(context, stories![index]),
                onDelete: () => _showDeleteConfirmation(stories![index]),
                onViewDetails: () => _showStoryDetails(stories![index]),
                onActiveToggle: (bool isActive) =>
                    _toggleStoryActive(stories![index], isActive),
              );
            },
          ),
        ],
      ),
    );
  }

  // Toggle story active status
  void _toggleStoryActive(Stories story, bool isActive) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isActive
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: isActive ? Colors.green[600] : Colors.orange[600],
            ),
            const SizedBox(width: 8),
            Text(
              isActive ? 'تفعيل النشر' : 'إلغاء تفعيل النشر',
              style: getBoldStyle(color: ColorManager.titleColor, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isActive
                  ? 'هل تريد تفعيل نشر قصة "${story.storyTitle}"؟'
                  : 'هل تريد إلغاء تفعيل نشر قصة "${story.storyTitle}"؟',
              style: getRegularStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isActive ? Colors.green : Colors.orange).withOpacity(
                  0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: isActive ? Colors.green[600] : Colors.orange[600],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isActive
                          ? 'ستصبح القصة مرئية للمستخدمين ويمكن الوصول إليها'
                          : 'ستصبح القصة مخفية عن المستخدمين ولن يمكن الوصول إليها',
                      style: getRegularStyle(
                        color: isActive
                            ? Colors.green[600]
                            : Colors.orange[600],
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
              await viewModel.updateStory(
                storyId: story.storyId!,
                isActive: isActive,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? Colors.green : Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(isActive ? 'تفعيل' : 'إلغاء تفعيل'),
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

  void _showEditStoryDialog(BuildContext context, Stories story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: viewModel),
          BlocProvider.value(value: problemsCubit),
        ],
        child: StoryFormDialog(
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
                // Handle story editing
                await viewModel.updateStory(
                            storyId: story.storyId!,
                            title: title,
                            storyDescription: description,
                            problemId: problemId,
                            gender: gender,
                            ageGroup: ageGroup,
                            categoryId: widget.categoryId,
                            isActive: true,
                            imageCover: imageCover.path.isNotEmpty ? imageCover : null,
                            bestFriendGender: bestFriendGender,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
        ),
      ),
    );
  }

  // void _showEditStoryDialog(Stories story) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => StoryFormDialog(
  //       story: story,
  //       categoryId: widget.categoryId,
  //       onSave: (title, description, problemId, gender, ageGroup, imageCover, bestFriendGender) async {
  //         Navigator.pop(context);
  //         await viewModel.updateStory(
  //           storyId: story.storyId!,
  //           title: title,
  //           storyDescription: description,
  //           problemId: problemId,
  //           gender: gender,
  //           ageGroup: ageGroup,
  //           categoryId: widget.categoryId,
  //           isActive: true,
  //           imageCover: imageCover.path.isNotEmpty ? imageCover : null,
  //           bestFriendGender: bestFriendGender,
  //         );
  //       },
  //     ),
  //   );
  // }

  void _showStoryDetails(Stories story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StoryDetailsSheet(
        story: story,
        onEdit: () {
          Navigator.pop(context);
          _showEditStoryDialog(context, story);
        },
        onDelete: () {
          Navigator.pop(context);
          _showDeleteConfirmation(story);
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
}
