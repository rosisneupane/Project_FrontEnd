import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

// Fake UserBasic class
class UserBasic {
  final String id;
  final String username;
  final String email;

  UserBasic({required this.id, required this.username, required this.email});
}

// Message model
class MessageResponse {
  final String id;
  final String conversationId;
  final UserBasic sender;
  final String content;
  final DateTime timestamp;

  MessageResponse({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final currentUser = UserBasic(
    id: 'user-123',
    username: 'Jerry',
    email: 'jerry@example.com',
  );

  final otherUser = UserBasic(
    id: 'user-456',
    username: 'Bot',
    email: 'bot@example.com',
  );

  final List<MessageResponse> messages = [
    MessageResponse(
      id: const Uuid().v4(),
      conversationId: 'conv-1',
      sender: UserBasic(id: 'user-456', username: 'Bot', email: 'bot@example.com'),
      content: 'Hi, Jerry 😊👋 How\'s your day?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newMessage = MessageResponse(
      id: const Uuid().v4(),
      conversationId: 'conv-1',
      sender: currentUser,
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(newMessage);
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF9F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Text to Text',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Ready',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isCurrentUser = msg.sender.id == currentUser.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isCurrentUser)
                        const CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.person),
                        ),
                      if (!isCurrentUser) const SizedBox(width: 10),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade50,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            msg.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      if (isCurrentUser) const SizedBox(width: 10),
                      if (isCurrentUser)
                        const CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.person_outline),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Send a message ...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
