import 'package:controller_stories/core/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../data/models/response/get_problems_dto.dart';
import '../bloc/Problems_cubit.dart';

class ProblemsPage extends StatefulWidget {
  const ProblemsPage({super.key});

  @override
  State<ProblemsPage> createState() => _ProblemsPageState();
}

class _ProblemsPageState extends State<ProblemsPage>
    with TickerProviderStateMixin {
  late ProblemsCubit viewModel;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    viewModel = getIt.get<ProblemsCubit>();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );

    // جلب البيانات عند تحميل الصفحة
    viewModel.fetchProblems();
    super.initState();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F6FF),
        appBar: _buildAppBar(),
        body: BlocConsumer<ProblemsCubit, ProblemsState>(
          listener: _handleStateChanges,
          builder: (context, state) {
            return _buildBody(state);
          },
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 2,
      backgroundColor: const Color(0xFF9B51E0),
      foregroundColor: Colors.white,
      shadowColor: const Color(0xFF9B51E0).withOpacity(0.3),
      title: const Text(
        'إدارة المشكلات',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => viewModel.fetchProblems(),
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          tooltip: 'تحديث',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(ProblemsState state) {
    if (state is GetProblemsLoading) {
      return _buildLoadingState();
    } else if (state is GetProblemsSuccess) {
      return _buildSuccessState(state);
    } else if (state is GetProblemsFailure) {
      return _buildErrorState();
    }
    return _buildEmptyState();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل المشكلات...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(GetProblemsSuccess state) {
    final problems = state.data?.data ?? [];

    if (problems.isEmpty) {
      return _buildEmptyProblemsState();
    }

    _fabAnimationController.forward();

    return RefreshIndicator(
      onRefresh: () async => viewModel.fetchProblems(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: problems.length,
          itemBuilder: (context, index) {
            return _buildProblemCard(problems[index], index);
          },
        ),
      ),
    );
  }

  Widget _buildProblemCard(DataProblems problem, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showProblemDetails(problem),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9B51E0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${problem.problemId}',
                        style: const TextStyle(
                          color: Color(0xFF9B51E0),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(value, problem),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: Color(0xFF9B51E0)),
                              SizedBox(width: 8),
                              Text('تعديل'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('حذف'),
                            ],
                          ),
                        ),
                      ],
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  problem.problemTitle ?? 'بدون عنوان',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  problem.problemDescription ?? 'بدون وصف',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(problem.creatAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
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

  Widget _buildEmptyProblemsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد مشكلات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على زر + لإضافة مشكلة جديدة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'حدث خطأ في تحميل البيانات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => viewModel.fetchProblems(),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9B51E0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'ابدأ بتحميل المشكلات',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: () => _showAddProblemDialog(),
        icon: const Icon(Icons.add),
        label: const Text('إضافة مشكلة'),
        backgroundColor: const Color(0xFF9B51E0),
        foregroundColor: Colors.white,
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ProblemsState state) {
    if (state is AddProblemsSuccess) {
      _showSuccessSnackBar('تم إضافة المشكلة بنجاح');
      viewModel.fetchProblems();
    } else if (state is EditProblemsSuccess) {
      _showSuccessSnackBar('تم تعديل المشكلة بنجاح');
      viewModel.fetchProblems();
    } else if (state is DeleteProblemsSuccess) {
      _showSuccessSnackBar('تم حذف المشكلة بنجاح');
      viewModel.fetchProblems();
    } else if (state is AddProblemsFailure ||
        state is EditProblemsFailure ||
        state is DeleteProblemsFailure) {
      viewModel.fetchProblems();
      _showErrorSnackBar('لا يمكن حذف مشكلة مرتبطة بقصة يمكنك التعديل فقط');
    }
  }

  void _handleMenuAction(String action, DataProblems problem) {
    switch (action) {
      case 'edit':
        _showEditProblemDialog(problem);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(problem);
        break;
    }
  }

  void _showAddProblemDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProblemFormBottomSheet(
        title: 'إضافة مشكلة جديدة',
        titleController: titleController,
        descriptionController: descriptionController,
        onSubmit: () {
          if (titleController.text.isNotEmpty &&
              descriptionController.text.isNotEmpty) {
            viewModel.addProblem(
              problemTitle: titleController.text,
              problemDescription: descriptionController.text,
            );
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _showEditProblemDialog(DataProblems problem) {
    final titleController = TextEditingController(text: problem.problemTitle);
    final descriptionController = TextEditingController(text: problem.problemDescription);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProblemFormBottomSheet(
        title: 'تعديل المشكلة',
        titleController: titleController,
        descriptionController: descriptionController,
        onSubmit: () {
          if (titleController.text.isNotEmpty &&
              descriptionController.text.isNotEmpty) {
            viewModel.editProblem(
              problemId:problem.problemId??0 ,

              problemTitle: titleController.text,
              problemDescription: descriptionController.text,
            );
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildProblemFormBottomSheet({
    required String title,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required VoidCallback onSubmit,
  }) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            CustomTextFormNew(title: 'عنوان المشكلة', hintText: 'عنوان المشكلة', controller: titleController,prefixIcon:  Icons.title,),

            const SizedBox(height: 16),

            CustomTextFormNew(title: 'وصف المشكلة', hintText: 'وصف المشكلة', controller: descriptionController,maxLines: 4,prefixIcon:  Icons.description,),


            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B51E0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  title.contains('إضافة') ? 'إضافة' : 'حفظ التغييرات',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(DataProblems problem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المشكلة "${problem.problemTitle}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.deleteProblem(problem.problemId!);
              Navigator.pop(context);
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

  void _showProblemDetails(DataProblems problem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'تفاصيل المشكلة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow('الرقم:', '#${problem.problemId}'),
            _buildDetailRow('العنوان:', problem.problemTitle ?? 'غير محدد'),
            _buildDetailRow('الوصف:', problem.problemDescription ?? 'غير محدد'),
            _buildDetailRow('تاريخ الإنشاء:', _formatDate(problem.creatAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF9B51E0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'غير محدد';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}