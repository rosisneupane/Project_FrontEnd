import 'package:flutter/material.dart';
import 'package:new_ui/theme/colors.dart';
import 'package:new_ui/theme/text_styles.dart';
import 'package:new_ui/user_services.dart';

class HomeTopBar extends StatelessWidget {
  HomeTopBar({super.key});
  final user = UserService();

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
            child: Image.asset("assets/images/ProPic1.png"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Welcome, ${user.user?.username}',
                style: AppTextStyles.title),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFFFB812),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Text('Golden', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
