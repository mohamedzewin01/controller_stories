import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../bloc/RequestStory_cubit.dart';
import '../../data/models/response/get_request_story_dto.dart';
import '../../data/models/response/get_all_stories_dto.dart';

class RequestStoryDetailsPage extends StatefulWidget {
  final DataRequest dataRequest;

  const RequestStoryDetailsPage({
    super.key,
    required this.dataRequest,
  });

  @override
  State<RequestStoryDetailsPage> createState() => _RequestStoryDetailsPageState();
}

class _RequestStoryDetailsPageState extends State<RequestStoryDetailsPage> {
  late RequestStoryCubit viewModel;
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();
  Data? _selectedStory;
  List<Data> _allStories = [];
  bool _isReplying = false;
  bool _isLoadingStories = true;

  @override
  void initState() {
    viewModel = getIt.get<RequestStoryCubit>();
    _loadStories();
    super.initState();
  }

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  void _loadStories() async {
    setState(() => _isLoadingStories = true);
    await viewModel.getAllStories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: BlocListener<RequestStoryCubit, RequestStoryState>(
          listener: _handleStateChanges,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequestDetails(),
                _buildUserInfo(),
                _buildChildInfo(),
                _buildReplySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'تفاصيل الطلب',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadStories,
          tooltip: 'تحديث القصص',
        ),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, RequestStoryState state) {
    if (state is GetAllStoriesSuccess) {
      setState(() {
        _allStories = state.entity?.data ?? [];
        _isLoadingStories = false;
      });
    }

    if (state is GetAllStoriesFailure) {
      setState(() => _isLoadingStories = false);
      _showErrorSnackBar('فشل في تحميل القصص');
    }

    if (state is AddRepliesSuccess) {
      setState(() {
        _isReplying = false;
        _selectedStory = null;
        _replyController.clear();
      });
      _replyFocusNode.unfocus();

      _showSuccessSnackBar('تم إرسال الرد بنجاح');
      Navigator.pop(context, true); // Return true to indicate success
    }

    if (state is AddRepliesFailure) {
      setState(() => _isReplying = false);
      _showErrorSnackBar('حدث خطأ في إرسال الرد');
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          textColor: Colors.white,
          onPressed: _loadStories,
        ),
      ),
    );
  }

  Widget _buildRequestDetails() {
    final request = widget.dataRequest.request;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تفاصيل المشكلة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                _buildStatusChip(request?.status),
              ],
            ),
            const SizedBox(height: 16),
            _buildProblemTitle(request?.problemTitle),
            const SizedBox(height: 16),
            if (request?.problemText?.isNotEmpty == true) ...[
              _buildProblemDescription(request!.problemText!),
              const SizedBox(height: 16),
            ],
            if (request?.notes?.isNotEmpty == true) ...[
              _buildNotes(request!.notes!),
              const SizedBox(height: 16),
            ],
            _buildDateInfo(request?.createdAt),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemTitle(String? title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepPurple[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'عنوان المشكلة:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title ?? 'بدون عنوان',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemDescription(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'وصف المشكلة:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotes(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ملاحظات إضافية:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber[200]!),
          ),
          child: Text(
            notes,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo(String? createdAt) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          'تاريخ الإنشاء: ${_formatDate(createdAt)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    final user = widget.dataRequest.user;
    if (user == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات ولي الأمر',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildUserAvatar(user.profileImage),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildUserDetails(user),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String? profileImage) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.deepPurple[100],
      backgroundImage: profileImage != null ? NetworkImage(profileImage) : null,
      child: profileImage == null
          ? Icon(
        Icons.person,
        size: 30,
        color: Colors.deepPurple[400],
      )
          : null,
    );
  }

  Widget _buildUserDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (user.email?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            user.email!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (user.age != null) ...[
          const SizedBox(height: 4),
          Text(
            'العمر: ${user.age} سنة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChildInfo() {
    final child = widget.dataRequest.child;
    if (child == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات الطفل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildChildAvatar(child.imageUrl),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildChildDetails(child),
                ),
              ],
            ),
            if (child.siblingsCount != null || child.friendsCount != null) ...[
              const SizedBox(height: 16),
              _buildChildStats(child),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChildAvatar(String? imageUrl) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.pink[100],
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
      child: imageUrl == null
          ? Icon(
        Icons.child_care,
        size: 30,
        color: Colors.pink[400],
      )
          : null,
    );
  }

  Widget _buildChildDetails(Child child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${child.firstName ?? ''} ${child.lastName ?? ''}'.trim(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (child.gender?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            'الجنس: ${child.gender}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (child.dateOfBirth?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            'تاريخ الميلاد: ${_formatDate(child.dateOfBirth)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChildStats(Child child) {
    return Row(
      children: [
        if (child.siblingsCount != null) ...[
          Icon(Icons.family_restroom, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            'الأشقاء: ${child.siblingsCount}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
        ],
        if (child.friendsCount != null) ...[
          Icon(Icons.people, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            'الأصدقاء: ${child.friendsCount}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }

  Widget _buildReplySection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إضافة رد',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            _buildReplyTextField(),
            const SizedBox(height: 16),
            _buildStorySelectionSection(),
            const SizedBox(height: 24),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyTextField() {
    return TextField(
      controller: _replyController,
      focusNode: _replyFocusNode,
      maxLines: 4,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        hintText: 'اكتب ردك هنا...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
        counterText: '',
      ),
      maxLength: 500,
      onChanged: (value) => setState(() {}), // Rebuild to update button state
    );
  }

  Widget _buildStorySelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختيار قصة (اختياري)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoadingStories)
          const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          )
        else if (_allStories.isEmpty)
          _buildNoStoriesAvailable()
        else
          _buildStorySelection(),
      ],
    );
  }

  Widget _buildNoStoriesAvailable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[600]),
          const SizedBox(width: 8),
          const Text(
            'لا توجد قصص متاحة',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStorySelection() {
    return Column(
      children: [
        if (_selectedStory != null) ...[
          _buildSelectedStoryCard(),
          const SizedBox(height: 12),
        ],
        OutlinedButton.icon(
          onPressed: _showStorySelectionDialog,
          icon: const Icon(Icons.book),
          label: Text(_selectedStory == null ? 'اختيار قصة' : 'تغيير القصة'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.deepPurple,
            side: const BorderSide(color: Colors.deepPurple),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedStoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepPurple[200]!),
      ),
      child: Row(
        children: [
          if (_selectedStory!.imageCover != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                _selectedStory!.imageCover!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.book, color: Colors.deepPurple[400]),
                    ),
              ),
            )
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.book, color: Colors.deepPurple[400]),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedStory!.storyTitle ?? 'بدون عنوان',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (_selectedStory!.storyDescription?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    _selectedStory!.storyDescription!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _selectedStory = null),
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    final isButtonEnabled = _replyController.text.trim().isNotEmpty && !_isReplying;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isButtonEnabled ? _sendReply : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isReplying
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Text(
          'إرسال الرد',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 1),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            displayText,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showStorySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogHeader(),
                Flexible(child: _buildStoriesList()),
                _buildDialogFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.book, color: Colors.deepPurple),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'اختيار قصة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _allStories.length,
      itemBuilder: (context, index) {
        final story = _allStories[index];
        final isSelected = _selectedStory?.storyId == story.storyId;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple[50] : null,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: Colors.deepPurple[200]!) : null,
          ),
          child: ListTile(
            onTap: () {
              setState(() => _selectedStory = story);
              Navigator.pop(context);
            },
            leading: _buildStoryThumbnail(story),
            title: Text(
              story.storyTitle ?? 'بدون عنوان',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: story.storyDescription?.isNotEmpty == true
                ? Text(
              story.storyDescription!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            )
                : null,
            trailing: _buildStoryTrailing(story, isSelected),
          ),
        );
      },
    );
  }

  Widget _buildStoryThumbnail(Data story) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: story.imageCover != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          story.imageCover!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.book, color: Colors.deepPurple[400]),
        ),
      )
          : Icon(Icons.book, color: Colors.deepPurple[400]),
    );
  }

  Widget _buildStoryTrailing(Data story, bool isSelected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (story.viewsCount != null) ...[
          Icon(Icons.visibility, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '${story.viewsCount}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
        ],
        if (isSelected)
          const Icon(Icons.check_circle, color: Colors.deepPurple, size: 20),
      ],
    );
  }

  Widget _buildDialogFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() => _selectedStory = null);
                Navigator.pop(context);
              },
              child: const Text('إلغاء الاختيار'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('تأكيد'),
            ),
          ),
        ],
      ),
    );
  }

  void _sendReply() {
    final replyText = _replyController.text.trim();

    if (replyText.isEmpty) {
      _showErrorSnackBar('يرجى كتابة نص الرد');
      return;
    }

    final requestId = widget.dataRequest.request?.id;
    if (requestId == null) {
      _showErrorSnackBar('خطأ في معرف الطلب');
      return;
    }

    setState(() => _isReplying = true);

    viewModel.addReplies(
      requestId: requestId,
      replyText: replyText,
      attachedStoryId: _selectedStory?.storyId,
    ).then((value) {
      Navigator.pop(context);
    });

  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return 'منذ ${difference.inDays} يوم';
      } else if (difference.inHours > 0) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inMinutes > 0) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else {
        return 'الآن';
      }
    } catch (e) {
      return dateString;
    }
  }
}