import 'package:controller_stories/core/api/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/response/fetch_clips_dto.dart';

class ClipItemWidget extends StatelessWidget {
  final Clips clip;
  final int index;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClipItemWidget({
    super.key,
    required this.clip,
    required this.index,
    required this.isPlaying,
    required this.onPlay,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildContent(),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF6C5CE7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'مقطع ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.drag_indicator,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (clip.imageUrl != null && clip.imageUrl!.isNotEmpty)
            _buildImage(),
          const SizedBox(height: 12),
          _buildText(),
          const SizedBox(height: 16),
          _buildAudioSection(),
          if (_hasPersonalizationOptions()) ...[
            const SizedBox(height: 16),
            _buildPersonalizationOptions(),
          ],
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl:"${ApiConstants.urlImage}${clip.imageUrl}",
          fit: BoxFit.fill,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        clip.clipText ?? 'لا يوجد نص',
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Color(0xFF2D3436),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildAudioSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C5CE7).withOpacity(0.1),
            const Color(0xFF74B9FF).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6C5CE7).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPlay,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPlaying ? Colors.red : const Color(0xFF6C5CE7),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: (isPlaying ? Colors.red : const Color(0xFF6C5CE7))
                        .withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPlaying ? 'جاري التشغيل...' : 'اضغط للتشغيل',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isPlaying ? Colors.red : const Color(0xFF6C5CE7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ملف صوتي',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.audiotrack,
            color: const Color(0xFF6C5CE7).withOpacity(0.6),
            size: 20,
          ),
        ],
      ),
    );
  }

  bool _hasPersonalizationOptions() {
    return (clip.insertChildName == 'true') ||
        (clip.insertSiblingsName == 'true') ||
        (clip.insertFriendsName == 'true') ||
        (clip.insertBestPlaymate == 'true');
  }

  Widget _buildPersonalizationOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: Colors.amber[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'خيارات التخصيص',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (clip.insertChildName == 'true')
                _buildPersonalizationTag('اسم الطفل', Icons.child_care),
              if (clip.insertSiblingsName == 'true')
                _buildPersonalizationTag('أسماء الأشقاء', Icons.family_restroom),
              if (clip.insertFriendsName == 'true')
                _buildPersonalizationTag('أسماء الأصدقاء', Icons.groups),
              if (clip.insertBestPlaymate == 'true')
                _buildPersonalizationTag('أفضل صديق', Icons.favorite),
            ],
          ),
          if (clip.pauseAfterName != null && clip.pauseAfterName! > 0) ...[
            const SizedBox(height: 8),
            Text(
              'توقف بعد الاسم: ${clip.pauseAfterName} مللي ثانية',
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPersonalizationTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.amber[700],
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.amber[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('تعديل'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF74B9FF),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, size: 18),
              label: const Text('حذف'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}