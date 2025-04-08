import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/screen/loading_screen.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
                                 Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoadingPage()),
                            );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/Logomark.svg',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 196,
                child: Text(
                  'CUHK\nAI Therapist',
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
            ],
          ),
        ),
      ),
    );
  }
}
