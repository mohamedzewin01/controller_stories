
import 'package:controller_stories/features/AudioName/presentation/pages/audio_names_page.dart';
import 'package:controller_stories/features/Problems/presentation/pages/Problems_page.dart';
import 'package:controller_stories/features/Stories/presentation/pages/Stories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:controller_stories/core/resources/style_manager.dart';
import 'package:controller_stories/core/widgets/custom_app_bar.dart';
import 'package:controller_stories/core/widgets/custom_text_form.dart';
import 'package:controller_stories/core/widgets/custom_snack_bar.dart';
import 'package:controller_stories/features/Categories/data/models/response/fetch_categories_dto.dart';
import 'package:controller_stories/features/Categories/data/models/request/update_category_request.dart';
import 'package:controller_stories/l10n/app_localizations.dart';
import '../../../../core/di/di.dart';
import '../bloc/Categories_cubit.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with TickerProviderStateMixin {
  late CategoriesCubit viewModel;
  late AnimationController _fabController;
  late AnimationController _listController;
  late Animation<double> _fabAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<CategoriesCubit>();

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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeOutCubic,
    ));

    // تحميل البيانات
    viewModel.fetchCategories();

    // بدء الأنيميشن
    Future.delayed(const Duration(milliseconds: 300), () {
      _fabController.forward();
      _listController.forward();
    });
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
            SliverCustomAppBar(
              iconActionOne: Icons.search_rounded,
              iconActionTwo: Icons.add_rounded,
              onTapActionOne: () => _showSearchDialog(),
              onTapActionTow: () => _showAddCategoryDialog(),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeaderSection(),
                    const SizedBox(height: 20),

                    // Categories List
                    BlocConsumer<CategoriesCubit, CategoriesState>(
                      listener: (context, state) {
                        if (state is CategoriesFailure) {
                          CustomSnackBar.showErrorSnackBar(
                            context,
                            message: state.exception.toString(),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is CategoriesLoading) {
                          return _buildLoadingState();
                        } else if (state is CategoriesSuccess) {
                          return _buildCategoriesList(
                              state.fetchCategoriesEntity);
                        } else if (state is CategoriesFailure) {
                          return _buildErrorState();
                        }
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
            onPressed: () => _showAddCategoryDialog(),
            backgroundColor: ColorManager.primaryColor,
            foregroundColor: Colors.white,
            elevation: 8,
            icon: const Icon(Icons.add_rounded, size: 24),
            label: Text(
              AppLocalizations.of(context)!.add,
              style: getBoldStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primaryColor.withOpacity(0.1),
            Colors.blue.shade50.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.category_rounded,
              color: ColorManager.primaryColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.categories,
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'إدارة وتنظيم الفئات',
                  style: getRegularStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(6, (index) => _buildLoadingShimmer()),
    );
  }

  Widget _buildLoadingShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
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
                  width: 150,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(dynamic categoriesEntity) {
    final categories = categoriesEntity.categories as List<Categories>?;

    if (categories == null || categories.isEmpty) {
      return _buildEmptyState();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          // Statistics Card
          _buildStatisticsCard(categories.length),
          const SizedBox(height: 20),

          // Categories Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(categories[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(int totalCategories) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إجمالي الفئات',
                  style: getRegularStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalCategories',
                  style: getBoldStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'نشطة',
              style: getBoldStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Categories category, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
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
                onTap: () => _showCategoryDetails(category),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorManager.primaryColor.withOpacity(0.2),
                                  Colors.blue.shade100.withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.category_rounded,
                              color: ColorManager.primaryColor,
                              size: 24,
                            ),
                          ),
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
                                  _showEditCategoryDialog(category);
                                  break;
                                case 'delete':
                                  _showDeleteConfirmation(category);
                                  break;
                              }
                            },
                            itemBuilder: (context) =>
                            [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded, size: 18,
                                        color: Colors.blue[600]),
                                    const SizedBox(width: 8),
                                    Text(AppLocalizations.of(context)!.edit),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_rounded, size: 18,
                                        color: Colors.red[600]),
                                    const SizedBox(width: 8),
                                    Text(AppLocalizations.of(context)!.delete),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Category Name
                      Text(
                        category.categoryName ?? 'بدون اسم',
                        style: getBoldStyle(
                          color: ColorManager.titleColor,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Category Description
                      Text(
                        category.categoryDescription ?? 'لا يوجد وصف',
                        style: getRegularStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Spacer(),

                      // Status and Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: category.isActive == '1'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              category.isActive == '1' ? 'نشط' : 'غير نشط',
                              style: getBoldStyle(
                                color: category.isActive == '1'
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Text(
                            _formatDate(category.createdAt),
                            style: getRegularStyle(
                              color: Colors.grey[500],
                              fontSize: 10,
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
              Icons.category_outlined,
              size: 64,
              color: ColorManager.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد فئات بعد',
            style: getBoldStyle(
              color: ColorManager.titleColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإضافة فئة جديدة لتنظيم المحتوى',
            style: getRegularStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddCategoryDialog(),
            icon: const Icon(Icons.add_rounded),
            label: Text(AppLocalizations.of(context)!.add),
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
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في تحميل البيانات',
            style: getBoldStyle(
              color: ColorManager.titleColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => viewModel.fetchCategories(),
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
  void _showAddCategoryDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AudioNamesPage(),
      ),
    );
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) =>
    //       CategoryFormDialog(
    //         onSave: (name, description, isActive) {
    //           viewModel.insertCategory(categoryName: name,
    //               categoryDescription: description,
    //               isActive: isActive);
    //           Navigator.pop(context);
    //           CustomSnackBar.showSuccessSnackBar(
    //             context,
    //             message: 'تم إضافة الفئة بنجاح',
    //           );
    //         },
    //       ),
    // );
  }

  void _showEditCategoryDialog(Categories category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CategoryFormDialog(
            category: category,
            onSave: (name, description, isActive) {
              viewModel.updateCategory(categoryId: category.categoryId ?? 0,
                  categoryName:name,
                  categoryDescription: description,
                  isActive: isActive);
              Navigator.pop(context);
              CustomSnackBar.showSuccessSnackBar(
                context,
                message: 'تم تحديث الفئة بنجاح',
              );
            },
          ),
    );
  }

  void _showDeleteConfirmation(Categories category) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'حذف الفئة',
              style: getBoldStyle(
                color: ColorManager.titleColor,
                fontSize: 18,
              ),
            ),
            content: Text(
              'هل أنت متأكد من حذف فئة "${category.categoryName}"؟',
              style: getRegularStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  viewModel.deleteCategory(category.categoryId ?? 0);
                  CustomSnackBar.showSuccessSnackBar(
                    context,
                    message: 'تم حذف الفئة بنجاح',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ],
          ),
    );
  }

  void _showCategoryDetails(Categories category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryDetailsSheet(category: category),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => ProblemsPage()
          // SearchDialog(),
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

// Category Form Dialog
class CategoryFormDialog extends StatefulWidget {
  final Categories? category;
  final Function(String name, String description, bool isActive) onSave;

  const CategoryFormDialog({
    super.key,
    this.category,
    required this.onSave,
  });

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.categoryName ?? '';
      _descriptionController.text = widget.category!.categoryDescription ?? '';
      _isActive = widget.category!.isActive == '1';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
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
                      widget.category == null ? Icons.add_rounded : Icons
                          .edit_rounded,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.category == null
                          ? 'إضافة فئة جديدة'
                          : 'تعديل الفئة',
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

              // Form Fields
              CustomTextFormNew(
                title: 'اسم الفئة',
                hintText: 'أدخل اسم الفئة',
                controller: _nameController,
                prefixIcon: Icons.category_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الفئة';
                  }
                  return null;
                },
              ),

              CustomTextFormNew(
                title: 'وصف الفئة',
                hintText: 'أدخل وصف الفئة',
                controller: _descriptionController,
                prefixIcon: Icons.description_rounded,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال وصف الفئة';
                  }
                  return null;
                },
              ),

              // Status Switch
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.toggle_on_rounded,
                      color: ColorManager.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'حالة الفئة',
                        style: getMediumStyle(
                          color: ColorManager.titleColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isActive,
                      onChanged: (value) => setState(() => _isActive = value),
                      activeColor: ColorManager.primaryColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave(
                            _nameController.text,
                            _descriptionController.text,
                            _isActive,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Category Details Sheet
class CategoryDetailsSheet extends StatelessWidget {
  final Categories category;

  const CategoryDetailsSheet({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryColor.withOpacity(0.2),
                      Colors.blue.shade100.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.category_rounded,
                  color: ColorManager.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.categoryName ?? 'بدون اسم',
                      style: getBoldStyle(
                        color: ColorManager.titleColor,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'تفاصيل الفئة',
                      style: getRegularStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Details Cards
          _buildDetailCard(
            'الوصف',
            category.categoryDescription ?? 'لا يوجد وصف',
            Icons.description_rounded,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  'الحالة',
                  category.isActive == '1' ? 'نشط' : 'غير نشط',
                  Icons.toggle_on_rounded,
                  color: category.isActive == '1' ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailCard(
                  'تاريخ الإنشاء',
                  _formatDate(category.createdAt),
                  Icons.calendar_today_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Navigate to edit
                  },
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('تعديل'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoriesPage(
                          categoryId:category.categoryId??0 ,
                          categoryName: category.categoryName??'',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.auto_stories_rounded),
                  label: const Text('القصص'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title,
      String value,
      IconData icon, {
        Color? color,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color ?? ColorManager.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: getMediumStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: getBoldStyle(
              color: color ?? ColorManager.titleColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'غير محدد';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'غير صحيح';
    }
  }
}

// Search Dialog
class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: ColorManager.primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'البحث في الفئات',
                    style: getBoldStyle(
                      color: ColorManager.titleColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),

            const SizedBox(height: 20),

            CustomTextFormNew(
              title: '',
              hintText: 'ابحث عن فئة...',
              controller: _searchController,
              prefixIcon: Icons.search_rounded,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) {
                // TODO: Implement search
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement search
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('بحث'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}