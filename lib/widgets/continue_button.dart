import 'package:flutter/material.dart';
import 'package:new_ui/theme/colors.dart';
import 'package:new_ui/theme/text_styles.dart';

class ContinueButtonWidget extends StatelessWidget {
  final VoidCallback onContinue;

  const ContinueButtonWidget({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(1000),
          onTap: onContinue,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Continue', style: AppTextStyles.button),
                const SizedBox(width: 12),
                Icon(Icons.arrow_forward, color: AppColors.white, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
