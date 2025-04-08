import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/screen/signin_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      body: SizedBox.expand(
        // makes the Column take full width and height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            SvgPicture.asset(
              'assets/images/LogoMarkWhite.svg',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 343,
              child: Text(
                'Welcome to the CUHK\nAI Therapist ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF4E3321),
                  fontSize: 30,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w800,
                  height: 1.27,
                  letterSpacing: -0.30,
                ),
              ),
            ),
            SizedBox(
              width: 343,
              child: Text(
                'Your mindful mental health AI companion for everyone, anywhere 🍃',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF736A66),
                  fontSize: 18,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w500,
                  height: 1.60,
                  letterSpacing: -0.07,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            FractionallySizedBox(
              widthFactor: 0.85, // between 0.80 and 0.90
              child: SvgPicture.asset(
                'assets/images/BotFrame.svg',
                fit: BoxFit.contain, // ensures it maintains aspect ratio
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                },
                child: ButtonPrimaryIcon()),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: const Color(0xFF736A66),
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.03,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: Text(
                      'Sign In.',
                      style: TextStyle(
                        color: const Color(0xFFEC7D1C),
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.03,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonPrimaryIcon extends StatelessWidget {
  const ButtonPrimaryIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: ShapeDecoration(
            color: const Color(0xFF4E3321),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.07,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward, // choose any icon from the Icons class
                    size: 30, // optional, default is 24.0
                    color: Colors.white, // optional
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
