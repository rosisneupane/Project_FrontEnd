import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_ui/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_ui/widgets/rounded_button.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final TextEditingController _textController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _status = false;
  bool _isSubmitting = false;

  String url = AppConfig.apiUrl;

Future<void> _submitSchedule() async {
  if (_selectedDate == null || _selectedTime == null || _textController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill in all fields")),
    );
    return;
  }

  setState(() => _isSubmitting = true);

  final DateTime combinedDateTime = DateTime(
    _selectedDate!.year,
    _selectedDate!.month,
    _selectedDate!.day,
    _selectedTime!.hour,
    _selectedTime!.minute,
  );

  final String formattedDate = _selectedDate!.toIso8601String().split('T')[0];
  final String formattedTime = combinedDateTime.toUtc().toIso8601String().split('T')[1];

  final body = {
    "date": formattedDate, // e.g. "2025-04-14"
    "time": formattedTime, // e.g. "10:57:09.980Z"
    "text": _textController.text.trim(),
    "status": _status,
  };

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse('$url/routines/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Schedule created successfully!")),
      );
      Navigator.pop(context);
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['message'] ?? "Error creating schedule")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    setState(() => _isSubmitting = false);
  }
}


  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      appBar: AppBar(
        title: const Text("Create Schedule"),
        backgroundColor: const Color(0xFF9BB067),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'e.g. Meeting with Dr. Chan',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9BB067)),
                ),
                ElevatedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    _selectedTime == null
                        ? 'Select Time'
                        : _selectedTime!.format(context),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9BB067)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Text('Mark as done:'),
                Switch(
                  value: _status,
                  onChanged: (val) => setState(() => _status = val),
                  activeColor: const Color(0xFF9BB067),
                ),
              ],
            ),
            const SizedBox(height: 30),

            RoundedButton(
              label: _isSubmitting ? 'Submitting...' : 'Create Schedule',
              onPressed: _submitSchedule,
            ),
          ],
        ),
      ),
    );
  }
}
