import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AssessmentOption extends StatelessWidget {
  final String text;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AssessmentOption({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.white,
          borderRadius: BorderRadius.circular(1234),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: isSelected ? AppColors.white : AppColors.disabled,
                      size: 24,
                    ),
                    child: icon,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: isSelected
                        ? AppTextStyles.optionSelected
                        : AppTextStyles.option,
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.white : AppColors.primary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Container(
                      margin: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}