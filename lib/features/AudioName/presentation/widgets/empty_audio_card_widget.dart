// lib/features/AudioName/presentation/widgets/empty_audio_card_widget.dart
import 'package:controller_stories/features/AudioName/data/models/response/audio_file_empty_dto.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/edit_audio_dialog.dart';
import 'package:flutter/material.dart';



class EmptyAudioCardWidget extends StatelessWidget {
  final DataFileEmpty item;

  const EmptyAudioCardWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 16),
            _buildNameAndInfo(),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_outline,
        color: Colors.orange[600],
        size: 24,
      ),
    );
  }

  Widget _buildNameAndInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name ?? 'اسم غير محدد',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.warning, size: 14, color: Colors.orange[600]),
              const SizedBox(width: 4),
              Text(
                'يحتاج إلى ملف صوتي',
                style: TextStyle(fontSize: 12, color: Colors.orange[600]),
              ),
            ],
          ),
          const SizedBox(height: 2),
          if (item.createdAt != null)
            Text(
              _formatDate(item.createdAt!),
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showAddAudioDialog(context),
      icon: const Icon(Icons.add, size: 18),
      label: const Text('إضافة صوت'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _showAddAudioDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddAudioDialog(item: item),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return 'منذ ${difference.inDays} يوم';
      } else if (difference.inHours > 0) {
        return 'منذ ${difference.inHours} ساعة';
      } else {
        return 'منذ قليل';
      }
    } catch (e) {
      return dateStr;
    }
  }
}