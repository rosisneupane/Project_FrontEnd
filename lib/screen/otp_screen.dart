import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_ui/config.dart';
import 'package:new_ui/screen/signin_screen.dart';

class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  String url = AppConfig.apiUrl;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$url/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp': otp,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // OTP verified successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
        // Navigate to next screen or perform another action
      } else {
        // Error from backend
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Verification failed')),
        );
      }
    } catch (e) {
      // Network or other error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF4E3321)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E3321),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We’ve sent a 6-digit verification code to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF736A66),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                letterSpacing: 32,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                counterText: "",
                hintText: "------",
                hintStyle: const TextStyle(
                  letterSpacing: 32,
                  fontSize: 20,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9BB067),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      // Resend code logic here
                    },
              child: const Text(
                'Resend Code',
                style: TextStyle(
                  color: Color(0xFFEC7D1C),
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
