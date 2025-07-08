import 'package:flutter/material.dart';

class AudioNameStatisticsWidget extends StatelessWidget {
  final int totalNames;
  final int namesWithAudio;
  final int namesWithoutAudio;

  const AudioNameStatisticsWidget({
    super.key,
    required this.totalNames,
    required this.namesWithAudio,
    required this.namesWithoutAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'إحصائيات الأسماء الصوتية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'إجمالي الأسماء',
                  totalNames.toString(),
                  Icons.group,
                  Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'بدون ملفات',
                  namesWithoutAudio.toString(),
                  Icons.audio_file,
                  Colors.orange[100]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'مع ملفات صوتية',
                  namesWithAudio.toString(),
                  Icons.audiotrack,
                  Colors.green[100]!,
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color backgroundColor) {
    return Container(

      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: backgroundColor == Colors.white ? Colors.blue[600] : Colors.black87,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: backgroundColor == Colors.white ? Colors.blue[600] : Colors.black87,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: backgroundColor == Colors.white ? Colors.blue[600] : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}