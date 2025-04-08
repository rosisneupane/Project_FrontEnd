import 'package:flutter/material.dart';
import 'package:new_ui/theme/colors.dart';
import 'package:new_ui/theme/text_styles.dart';

class HeaderWidget extends StatelessWidget {
  final VoidCallback onBack;

  const HeaderWidget({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary),
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left),
              color: AppColors.primary,
              onPressed: onBack,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Assessment', style: AppTextStyles.title),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Text('1 of 14', style: AppTextStyles.progress),
          ),
        ],
      ),
    );
  }
}
