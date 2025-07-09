
import 'package:flutter/material.dart';


class WelcomeCardWidget extends StatelessWidget {
  const WelcomeCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[50]!, Colors.indigo[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigo[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.person_add, size: 48, color: Colors.indigo[600]),
          const SizedBox(height: 16),
          Text(
            'إضافة اسم جديد',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف اسم الطفل مع تسجيل صوتي واضح للنطق الصحيح',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.indigo[700],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
















