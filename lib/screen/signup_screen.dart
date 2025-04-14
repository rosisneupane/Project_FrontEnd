import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:new_ui/config.dart';
import 'package:new_ui/screen/assesment_screen.dart';
import 'package:new_ui/screen/otp_screen.dart';
import 'package:new_ui/screen/signin_screen.dart';
import 'package:new_ui/widgets/rounded_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _guardianEmailController =
      TextEditingController();
  final TextEditingController _guardianPhoneController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _guardianEmailController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    final String url = AppConfig.apiUrl;

    final String _username = _usernameController.text.trim();
    final String _email = _emailController.text.trim();
    final String _password = _passwordController.text.trim();
    final String _guardianEmail = _guardianEmailController.text.trim();
    final String _guardianPhone = _guardianPhoneController.text.trim();

    if (_password != _confirmPasswordController.text.trim()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$url/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _username,
          'email': _email,
          'password': _password,
          'guardianEmail': _guardianEmail,
          'guardianPhone': _guardianPhone,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Registration successful"),
              backgroundColor: Colors.green),
        );
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => OTPScreen(email: _email)),
);

      } else {
        final error =
            json.decode(response.body)['message'] ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
                       Stack(
              children: [
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    height: 250,
                    color: const Color(0xFF9BB067),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/LogoMarkWhiteTwo.svg',
                        width: 60,
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              'Sign Up For Free',
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Username',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Your username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email field (same as before)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Email Address',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'your@email.com',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Passwords, Guardian Email & Phone
                  // [Same fields as before, using controllers]

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Password',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password...',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Confirm Password',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password...',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Guardian Email',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _guardianEmailController,
                    decoration: InputDecoration(
                      hintText: 'guardian@email.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Guardian Phone',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _guardianPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '+1234567890',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _isLoading
                      ? const CircularProgressIndicator()
                      : RoundedButton(
                          label: 'Sign Up',
                          onPressed: _registerUser,
                        ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()));
                        },
                        child: const Text(
                          'Sign In.',
                          style: TextStyle(color: Color(0xFFEC7D1C)),
                        ),
                      ),
                    ],
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

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
