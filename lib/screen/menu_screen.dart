import 'package:flutter/material.dart';
import 'package:new_ui/theme/colors.dart';

class MenuItem {
  final String title;
  final Widget screen;

  MenuItem({required this.title, required this.screen});
}



class MenuScreen extends StatelessWidget {
  final String topBarTitle;
  final List<MenuItem> menuItems;

  const MenuScreen({
    super.key,
    required this.topBarTitle,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topBarTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: menuItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item.screen),
              );
            },
            child: FeatureContainer(
              icon: Icons.arrow_forward_ios, // Default icon
              label: item.title,
            ),
          );
        },
      ),
    );
  }
}


class FeatureContainer extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureContainer({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Icon(icon, size: 28, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4E3321),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

