import 'package:flutter/material.dart';

class NameInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const NameInputWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'اسم الطفل',
          hintText: 'أدخل اسم الطفل هنا...',
          prefixIcon: Icon(Icons.person, color: Colors.indigo[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          labelStyle: TextStyle(color: Colors.grey[700]),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}