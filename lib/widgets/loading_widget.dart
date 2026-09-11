import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  static const Color primaryGreen = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: primaryGreen));
  }
}
