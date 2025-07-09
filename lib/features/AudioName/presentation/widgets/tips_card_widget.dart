import 'package:flutter/material.dart';

class TipsCardWidget extends StatelessWidget {
  const TipsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber[700], size: 24),
              const SizedBox(width: 8),
              Text(
                'نصائح للحصول على أفضل النتائج',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...[
            'اجعل النطق واضحاً ومفهوماً',
            'سجل في مكان هادئ بدون ضوضاء',
            'كرر الاسم 2-3 مرات في التسجيل',
            'استخدم نبرة طبيعية ومريحة'
          ].map((tip) => _buildTipItem(tip)).toList(),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.amber[700],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.amber[800],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}