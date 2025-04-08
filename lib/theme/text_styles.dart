import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle time = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle title = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: -0.1,
  );

  static const TextStyle progress = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.secondary,
    letterSpacing: -0.028,
  );

  static const TextStyle question = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: -0.3,
    height: 1.27,
  );

  static const TextStyle option = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: -0.048,
  );

  static const TextStyle optionSelected = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: -0.048,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: -0.072,
  );
}