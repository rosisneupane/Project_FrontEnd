import 'package:flutter/material.dart';

class ThemeConstants {
  static const Color primaryBrown = Color(0xFF4F3422);
  static const Color primaryGreen = Color(0xFF9BB168);
  static const Color backgroundColor = Color(0xFFE5EAD7);
  static const Color progressBarBg = Color(0xFFE8DDD9);
  static const Color progressBarFg = Color(0xFF926247);

  static const double defaultBorderRadius = 40.0;
  static const double maxScreenWidth = 480.0;

  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    color: primaryBrown,
    height: 1.27, // to achieve 38px line height
  );

  static const TextStyle tagStyle = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.05,
    color: primaryBrown,
  );
}