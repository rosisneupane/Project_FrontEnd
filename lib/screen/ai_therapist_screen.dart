import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/widgets/conversation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AiTherapistScreen extends StatefulWidget {
  const AiTherapistScreen({super.key});

  @override
  State<AiTherapistScreen> createState() => _AiTherapistScreenState();
}

class _AiTherapistScreenState extends State<AiTherapistScreen> {
  String url = AppConfig.apiUrl;
  String? _conversationId;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  void _fetchConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('JWT Token not found');

      final response =
          await http.get(Uri.parse('$url/aiconversations/'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _conversations =
              data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to start conversation');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch conversations.")),
      );
    }
  }

  void _fetchMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('JWT Token not found');

      final response = await http.get(
          Uri.parse('$url/aiconversations/$_conversationId/messages'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _messages = data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to start conversation');
      }
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch conversations.")),
      );
    }
  }

  Future<void> _sendMessageToConversation(String text, String token) async {
    final uuid = Uuid();
    final now = DateTime.now().toUtc().toIso8601String();

    setState(() {
      _messages.add({
        "id": uuid.v4(), // Generates a unique UUID
        "sender": "user",
        "content": text,
        "timestamp": now, // UTC ISO 8601 timestamp
      });
    });
_scrollToBottom();
    final response = await http.post(
      Uri.parse('$url/aiconversations/$_conversationId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"content": text}),
    );

    if (response.statusCode == 200) {
      final messageData = json.decode(response.body);
      setState(() {
        _messages.add({
          "id": messageData["id"],
          "sender": messageData["sender"],
          "content": messageData["content"],
          "timestamp": messageData["timestamp"],
        });
      });
      _inputController.clear();
      _scrollToBottom();
    } else {
      throw Exception('Failed to send message');
    }
  }

  void _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter something first!")),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('JWT Token not found');

      if (_conversationId == null) {
        final response = await http.post(
          Uri.parse('$url/aiconversations/'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({"name": text}),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _conversationId = data["id"];
            _conversations.add({
              "id": data["id"],
              "name": data["name"],
              "created_at": data["created_at"]
            });
          });
        } else {
          throw Exception('Failed to start conversation');
        }
      }

      await _sendMessageToConversation(text, token);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send message.")),
      );
    }
  }

  void _scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
}


  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isUser = message['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFEC7D1C) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message['content'],
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: ConversationDrawer(
        conversationId: _conversationId,
        conversations: _conversations,
        onNewConversationTap: () {
          setState(() {
            _conversationId = null;
            _messages = [];
          });
          Navigator.of(context).pop(); // Optional: Close drawer
        },
        onConversationTap: (id) {
          setState(() {
            _conversationId = id;
            _fetchMessages();
          });
          Navigator.of(context).pop(); // Optional: Close drawer
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child:
                        Text('AI Therapist Chat', style: AppTextStyles.title),
                  ),
                ],
              ),
            ),

            // Messages
            _conversationId == null
                ? const Text(
                    "How would you like to\n interact with the AI?",
                    style: AppTextStyles.question,
                    textAlign: TextAlign.center,
                  )
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
                  ),

            // Input field
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        fillColor: Colors.grey[100],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEC7D1C),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
