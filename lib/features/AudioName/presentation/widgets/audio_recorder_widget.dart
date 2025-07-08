import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class AudioRecorderWidget extends StatefulWidget {
  final Function(File) onAudioRecorded;

  const AudioRecorderWidget({
    super.key,
    required this.onAudioRecorded,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _hasPermission = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _checkPermission();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
      });
    } else {
      final result = await Permission.microphone.request();
      setState(() {
        _hasPermission = result.isGranted;
      });
    }
  }

  Future<void> _startRecording() async {
    if (!_hasPermission) {
      await _checkPermission();
      return;
    }

    setState(() {
      _isRecording = true;
    });

    _pulseController.repeat(reverse: true);

    // هنا يجب إضافة منطق التسجيل الفعلي
    // يمكن استخدام مكتبة مثل record أو flutter_sound
  }

  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false;
    });

    _pulseController.stop();

    // هنا يجب إضافة منطق إيقاف التسجيل وحفظ الملف
    // وإرجاع الملف عبر widget.onAudioRecorded
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Column(
          children: [
            Icon(Icons.mic_off, size: 48, color: Colors.red[400]),
            const SizedBox(height: 12),
            const Text(
              'مطلوب إذن الميكروفون',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'لتسجيل الصوت، يرجى منح إذن الوصول للميكروفون',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPermission,
              child: const Text('طلب الإذن'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isRecording ? _pulseAnimation.value : 1.0,
                child: GestureDetector(
                  onTap: _isRecording ? _stopRecording : _startRecording,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red[100] : Colors.blue[100],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isRecording ? Colors.red[300]! : Colors.blue[300]!,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      size: 40,
                      color: _isRecording ? Colors.red[600] : Colors.blue[600],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            _isRecording ? 'اضغط لإيقاف التسجيل' : 'اضغط لبدء التسجيل',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _isRecording ? Colors.red[600] : Colors.blue[600],
            ),
          ),
          if (_isRecording) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'جاري التسجيل...',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}