// lib/features/AudioName/presentation/widgets/animated_audio_card.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../data/models/response/get_names_audio_dto.dart';

class AnimatedAudioCard extends StatefulWidget {
  final DataAudio audio;
  final VoidCallback? onPlay;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isPlaying;

  const AnimatedAudioCard({
    super.key,
    required this.audio,
    this.onPlay,
    this.onEdit,
    this.onDelete,
    this.isPlaying = false,
  });

  @override
  State<AnimatedAudioCard> createState() => _AnimatedAudioCardState();
}

class _AnimatedAudioCardState extends State<AnimatedAudioCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedAudioCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isPlaying ? _pulseAnimation.value : 1.0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isPlaying ? Colors.blue[300]! : Colors.transparent,
                width: widget.isPlaying ? 2 : 0,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isPlaying
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  spreadRadius: widget.isPlaying ? 3 : 1,
                  blurRadius: widget.isPlaying ? 12 : 8,
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Hero(
                tag: 'avatar_${widget.audio.nameAudioId}',
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: widget.isPlaying
                      ? Colors.blue[100]
                      : Colors.grey[100],
                  child: Icon(
                    widget.isPlaying ? Icons.volume_up : Icons.person,
                    color: widget.isPlaying
                        ? Colors.blue[600]
                        : Colors.grey[600],
                    size: 28,
                  ),
                ),
              ),
              title: Text(
                widget.audio.name ?? 'اسم غير محدد',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: widget.isPlaying ? Colors.blue[800] : Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600]
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(widget.audio.createdAt ?? ''),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  if (widget.isPlaying) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_fill,
                          size: 14,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'جاري التشغيل...',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              trailing: _buildActionButtons(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: widget.isPlaying ? Icons.pause : Icons.play_arrow,
          color: widget.isPlaying ? Colors.red : Colors.green,
          onPressed: widget.onPlay,
        ),
        const SizedBox(width: 4),
        _buildActionButton(
          icon: Icons.edit,
          color: Colors.orange,
          onPressed: widget.onEdit,
        ),
        const SizedBox(width: 4),
        _buildActionButton(
          icon: Icons.delete,
          color: Colors.red,
          onPressed: widget.onDelete,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        color: color,
        onPressed: onPressed,
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
      ),
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
      } else if (difference.inMinutes > 0) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else {
        return 'منذ قليل';
      }
    } catch (e) {
      return dateStr;
    }
  }
}









