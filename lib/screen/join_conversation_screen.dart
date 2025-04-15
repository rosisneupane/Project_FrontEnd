import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:new_ui/config.dart';
import 'package:new_ui/screen/forum_message_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinConversationScreen extends StatefulWidget {
  const JoinConversationScreen({super.key});

  @override
  State<JoinConversationScreen> createState() => _JoinConversationScreenState();
}

class _JoinConversationScreenState extends State<JoinConversationScreen> {
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    try {
      String url = AppConfig.apiUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('JWT Token not found');
      }

      final response = await http.get(
        Uri.parse('$url/conversations/unjoined'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _conversations =
              data.map((item) => item as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load conversations.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong: $e';
        _isLoading = false;
      });
    }
  }

  void _joinConversation(String conversationId) async{
    // Handle join logic here, e.g., call an API or navigate
    print("Joining conversation: $conversationId");
    // Example: Navigator.pushNamed(context, '/chat', arguments: convo);
        String url = AppConfig.apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('JWT Token not found');
    }

    try {
      final response = await http.post(Uri.parse('$url/conversations/join'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({"conversation_id": conversationId}));
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ForumMessagesScreen(
                    conversationId: conversationId,
                  )),
        );
      } else {
        throw Exception("Failed to join conversations");
      }
    } catch (e) {
      print("Error fetching conversations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      appBar: AppBar(
        title: const Text('Join Conversation'),
        backgroundColor: const Color(0xFF9BB067),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _conversations.isEmpty
                  ? const Center(child: Text('No conversations found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _conversations.length,
                      itemBuilder: (context, index) {
                        final convo = _conversations[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 3,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        convo['name'] ?? 'Unnamed',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _joinConversation(convo["id"]),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF9BB067),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('Join'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  convo['details'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
