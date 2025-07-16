import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../bloc/RequestStory_cubit.dart';
import '../../data/models/response/get_request_story_dto.dart';
import 'request_story_details_page.dart';

class RequestStoryPage extends StatefulWidget {
  const RequestStoryPage({super.key});

  @override
  State<RequestStoryPage> createState() => _RequestStoryPageState();
}

class _RequestStoryPageState extends State<RequestStoryPage> {
  late RequestStoryCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<RequestStoryCubit>();
    viewModel.getRequestStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'طلبات القصص',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<RequestStoryCubit, RequestStoryState>(
          builder: (context, state) {
            if (state is RequestStoryLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              );
            }

            if (state is RequestStoryFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[400],
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'حدث خطأ في تحميل البيانات',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.getRequestStories(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is RequestStorySuccess) {
              final requests = state.entity?.data ?? [];

              if (requests.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        color: Colors.grey[400],
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد طلبات قصص حالياً',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => viewModel.getRequestStories(),
                color: Colors.deepPurple,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return RequestStoryCard(
                      dataRequest: requests[index],
                      onTap: () => _navigateToDetails(requests[index]),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _navigateToDetails(DataRequest dataRequest) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestStoryDetailsPage(
          dataRequest: dataRequest,
        ),
      ),
    );
  }
}

class RequestStoryCard extends StatelessWidget {
  final DataRequest dataRequest;
  final VoidCallback onTap;

  const RequestStoryCard({
    super.key,
    required this.dataRequest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final request = dataRequest.request;
    final user = dataRequest.user;
    final child = dataRequest.child;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      request?.problemTitle ?? 'بدون عنوان',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(request?.status),
                ],
              ),

              const SizedBox(height: 12),

              // Problem description
              if (request?.problemText != null && request!.problemText!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    request.problemText!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              const SizedBox(height: 12),

              // User and child info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.deepPurple[100],
                    backgroundImage: user?.profileImage != null
                        ? NetworkImage(user!.profileImage!)
                        : null,
                    child: user?.profileImage == null
                        ? Icon(
                      Icons.person,
                      color: Colors.deepPurple[400],
                    )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (child != null)
                          Text(
                            'طفل: ${child.firstName ?? ''} (${child.gender ?? ''})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatDate(request?.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status?.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        displayText = 'في الانتظار';
        break;
      case 'completed':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        displayText = 'مكتمل';
        break;
      case 'rejected':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        displayText = 'مرفوض';
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
        displayText = status ?? 'غير محدد';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return 'منذ ${difference.inDays} يوم';
      } else if (difference.inHours > 0) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inMinutes > 0) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else {
        return 'الآن';
      }
    } catch (e) {
      return '';
    }
  }
}