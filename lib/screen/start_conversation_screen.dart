import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StartConversationScreen extends StatefulWidget {
  const StartConversationScreen({super.key});

  @override
  State<StartConversationScreen> createState() =>
      _StartConversationScreenState();
}

class _StartConversationScreenState extends State<StartConversationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  List<Map<String, String>> users = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    String url = AppConfig.apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('JWT Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$url/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          users = data
              .map((user) => {
                    'id': user['id'].toString(),
                    'username': user['username'].toString(),
                    'email': user['email'].toString(),
                  })
              .toList();
        });
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  List<Map<String, String>> _selectedUsers = [];

  void _toggleUser(String userId) {
    final user = users.firstWhere((u) => u['id'] == userId);
    setState(() {
      if (_selectedUsers.any((u) => u['id'] == userId)) {
        _selectedUsers.removeWhere((u) => u['id'] == userId);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  void _submitConversation() async {
    String url = AppConfig.apiUrl;
    final name = _nameController.text.trim();
    final details = _detailsController.text.trim();
    final userIds = _selectedUsers.map((user) => user['id']).toList();

    if (name.isEmpty || details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    print({
      'name': name,
      'details': details,
      'user_ids': userIds,
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('JWT Token not found');
      }
      setState(() => loading = true);

      final response = await http.post(
        Uri.parse('$url/conversations/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body:
            jsonEncode({"name": name, "details": details, "user_ids": userIds}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversation Created successfully')),
        );
      } else {
        throw Exception('Failed to check mood status');
      }
    } catch (e) {
      throw Exception('Failed to check mood status');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      appBar: AppBar(
        title: const Text('Start a Conversation'),
        backgroundColor: const Color(0xFF9BB067),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conversation Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g. Coping Strategies Group',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _detailsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write a few lines about the conversation...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Participants',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: null,
              items: users.map((user) {
                final isSelected =
                    _selectedUsers.any((u) => u['id'] == user['id']);
                return DropdownMenuItem(
                  value: user['id'],
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text('${user['username']} (${user['email']})'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (userId) {
                if (userId != null) {
                  _toggleUser(userId);
                }
              },
              decoration: InputDecoration(
                hintText: 'Tap to add or remove a user',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedUsers.map((user) {
                return Chip(
                  label: Text(user['email']!),
                  backgroundColor: const Color(0xFFEC7D1C).withOpacity(0.2),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _toggleUser(user['id']!),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC7D1C),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                onPressed: _submitConversation,
                child: const Text(
                  'Create Conversation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
