import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../data/models/response/get_names_audio_dto.dart';

class AudioDetailsPage extends StatefulWidget {
  final DataAudio audioData;

  const AudioDetailsPage({super.key, required this.audioData});

  @override
  State<AudioDetailsPage> createState() => _AudioDetailsPageState();
}

class _AudioDetailsPageState extends State<AudioDetailsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.audioData.name ?? 'تفاصيل الاسم'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildAudioPlayerCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue[100],
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.audioData.name ?? 'اسم غير محدد',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تاريخ الإضافة: ${widget.audioData.createdAt ?? 'غير محدد'}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.audiotrack,
            size: 48,
            color: Colors.green[600],
          ),
          const SizedBox(height: 16),
          const Text(
            'مشغل الصوت',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // زر التشغيل الرئيسي
          GestureDetector(
            onTap: _playPause,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _isPlaying ? Colors.red[100] : Colors.green[100],
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isPlaying ? Colors.red[300]! : Colors.green[300]!,
                  width: 3,
                ),
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 40,
                color: _isPlaying ? Colors.red[600] : Colors.green[600],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // شريط التقدم
          Column(
            children: [
              Slider(
                value: _position.inSeconds.toDouble(),
                max: _duration.inSeconds.toDouble(),
                onChanged: (value) async {
                  await _audioPlayer.seek(Duration(seconds: value.toInt()));
                },
                activeColor: Colors.blue[600],
                inactiveColor: Colors.grey[300],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_position),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _playPause() async {
    if (widget.audioData.audioFile == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioData.audioFile!));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}