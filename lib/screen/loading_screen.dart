import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/screen/welcome_screen.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF251404),
      body: GestureDetector(
        onTap: () {
                                 Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WelcomePage()),
                            );
        },
        child: SizedBox.expand(
          child: SvgPicture.asset(
            'assets/images/LoadingPage.svg',
            fit: BoxFit.cover, // Use BoxFit.contain if you want to keep the aspect ratio
          ),
        ),
      ),
    );
  }
}
