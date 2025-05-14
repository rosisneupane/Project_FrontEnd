import 'package:flutter/material.dart';
import 'package:new_ui/theme/colors.dart';

class HomeFeatureContainer extends StatelessWidget {
  final IconData icon;
  final String label;
  const HomeFeatureContainer({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 46,
              color: AppColors.primary), // Change primary color if needed
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4E3321),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
