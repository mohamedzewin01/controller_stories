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
  List<DataRequest> _allRequests = [];
  List<DataRequest> _filteredRequests = [];
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    viewModel = getIt.get<RequestStoryCubit>();
    _loadRequestStories();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRequestStories() {
    viewModel.getRequestStories();
  }

  void _filterRequests() {
    String searchQuery = _searchController.text.toLowerCase();

    setState(() {
      _filteredRequests = _allRequests.where((request) {
        // Filter by status
        bool statusMatch = _selectedFilter == 'all' ||
            request.request?.status?.toLowerCase() == _selectedFilter;

        // Filter by search query
        bool searchMatch = searchQuery.isEmpty ||
            (request.request?.problemTitle?.toLowerCase().contains(searchQuery) ?? false) ||
            (request.request?.problemText?.toLowerCase().contains(searchQuery) ?? false) ||
            ('${request.user?.firstName ?? ''} ${request.user?.lastName ?? ''}'.toLowerCase().contains(searchQuery));

        return statusMatch && searchMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: BlocListener<RequestStoryCubit, RequestStoryState>(
          listener: (context, state) {
            if (state is RequestStorySuccess) {
              setState(() {
                _allRequests = state.entity?.data ?? [];
                _filterRequests();
              });
            }
          },
          child: Column(
            children: [
              _buildFiltersSection(),
              Expanded(
                child: BlocBuilder<RequestStoryCubit, RequestStoryState>(
                  builder: (context, state) {
                    if (state is RequestStoryLoading) {
                      return _buildLoadingState();
                    }

                    if (state is RequestStoryFailure) {
                      return _buildErrorState();
                    }

                    if (state is RequestStorySuccess) {
                      if (_filteredRequests.isEmpty) {
                        return _buildEmptyState();
                      }

                      return _buildRequestsList();
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _loadRequestStories,
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // Handle notifications
          },
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'البحث في الطلبات...',
              prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.deepPurple),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              fillColor: Colors.grey[50],
              filled: true,
            ),
            onChanged: (value) => _filterRequests(),
          ),

          const SizedBox(height: 16),

          // Status filters
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'الكل', _getRequestCount('all')),
                      const SizedBox(width: 8),
                      _buildFilterChip('pending', 'في الانتظار', _getRequestCount('pending')),
                      const SizedBox(width: 8),
                      _buildFilterChip('completed', 'مكتمل', _getRequestCount('completed')),
                      const SizedBox(width: 8),
                      _buildFilterChip('rejected', 'مرفوض', _getRequestCount('rejected')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter, String label, int count) {
    bool isSelected = _selectedFilter == filter;

    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
          _filterRequests();
        });
      },
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.deepPurple[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.deepPurple[800] : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: Colors.deepPurple[800],
    );
  }

  int _getRequestCount(String filter) {
    if (filter == 'all') return _allRequests.length;
    return _allRequests.where((request) =>
    request.request?.status?.toLowerCase() == filter).length;
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.deepPurple),
          SizedBox(height: 16),
          Text(
            'جاري تحميل الطلبات...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'حدث خطأ في تحميل البيانات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadRequestStories,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = _selectedFilter == 'all'
        ? 'لا توجد طلبات قصص حالياً'
        : 'لا توجد طلبات ${_getFilterDisplayName(_selectedFilter)}';

    String description = _searchController.text.isNotEmpty
        ? 'جرب البحث بكلمات مختلفة أو امسح مربع البحث'
        : 'ستظهر الطلبات الجديدة هنا عند وصولها';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isNotEmpty ? Icons.search_off : Icons.inbox_outlined,
              color: Colors.grey[400],
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchController.text.isNotEmpty || _selectedFilter != 'all') ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedFilter = 'all';
                    _filterRequests();
                  });
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('مسح المرشحات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'pending': return 'في الانتظار';
      case 'completed': return 'مكتملة';
      case 'rejected': return 'مرفوضة';
      default: return '';
    }
  }

  Widget _buildRequestsList() {
    return RefreshIndicator(
      onRefresh: () async => _loadRequestStories(),
      color: Colors.deepPurple,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredRequests.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RequestStoryCard(
              dataRequest: _filteredRequests[index],
              onTap: () => _navigateToDetails(_filteredRequests[index]),
              searchQuery: _searchController.text,
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetails(DataRequest dataRequest) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestStoryDetailsPage(
          dataRequest: dataRequest,
        ),
      ),
    );

    // If reply was sent successfully, refresh the list
    if (result == true) {
      _loadRequestStories();
    }
  }
}

class RequestStoryCard extends StatelessWidget {
  final DataRequest dataRequest;
  final VoidCallback onTap;
  final String searchQuery;

  const RequestStoryCard({
    super.key,
    required this.dataRequest,
    required this.onTap,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final request = dataRequest.request;
    final user = dataRequest.user;
    final child = dataRequest.child;

    return Card(
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
              _buildHeader(request, context),
              const SizedBox(height: 12),
              if (request?.problemText?.isNotEmpty == true)
                _buildProblemDescription(request!.problemText!, context),
              const SizedBox(height: 12),
              _buildUserInfo(user, child, request?.createdAt, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(RequestUser? request, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHighlightedText(
                request?.problemTitle ?? 'بدون عنوان',
                searchQuery,
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                context,
              ),
              if (request?.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.note, size: 12, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text(
                        'يحتوي على ملاحظات',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.amber[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildStatusChip(request?.status),
            const SizedBox(height: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProblemDescription(String problemText, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: _buildHighlightedText(
        problemText,
        searchQuery,
        TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          height: 1.4,
        ),
        context,
        maxLines: 3,
      ),
    );
  }

  Widget _buildUserInfo(User? user, Child? child, String? createdAt, BuildContext context) {
    return Row(
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
            size: 20,
          )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHighlightedText(
                '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim(),
                searchQuery,
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                context,
              ),
              if (child != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.child_care, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${child.firstName ?? ''} (${child.gender ?? ''})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatDate(createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            if (child?.siblingsCount != null || child?.friendsCount != null) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (child!.siblingsCount != null) ...[
                    Icon(Icons.family_restroom, size: 10, color: Colors.grey[500]),
                    Text(
                      '${child.siblingsCount}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 4),
                  ],
                  if (child.friendsCount != null) ...[
                    Icon(Icons.people, size: 10, color: Colors.grey[500]),
                    Text(
                      '${child.friendsCount}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildHighlightedText(
      String text,
      String query,
      TextStyle style,
      BuildContext context, {
        int? maxLines,
      }) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final List<TextSpan> spans = [];
    int start = 0;

    while (start < text.length) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start), style: style));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: style));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: style.copyWith(
          backgroundColor: Colors.yellow[200],
          fontWeight: FontWeight.bold,
        ),
      ));

      start = index + query.length;
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow:  TextOverflow.ellipsis ,
    );
  }

  Widget _buildStatusChip(String? status) {
    Color backgroundColor;
    Color textColor;
    String displayText;
    IconData icon;

    switch (status?.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        displayText = 'في الانتظار';
        icon = Icons.hourglass_empty;
        break;
      case 'completed':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        displayText = 'مكتمل';
        icon = Icons.check_circle;
        break;
      case 'rejected':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        displayText = 'مرفوض';
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
        displayText = status ?? 'غير محدد';
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            displayText,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

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