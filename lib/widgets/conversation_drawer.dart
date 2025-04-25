import 'package:flutter/material.dart';
import 'package:new_ui/theme/text_styles.dart';

class ConversationDrawer extends StatelessWidget {
  final String? conversationId;
  final List<Map<String, dynamic>> conversations;
  final VoidCallback onNewConversationTap;
  final void Function(String conversationId) onConversationTap;

  const ConversationDrawer(
      {super.key,
      required this.conversationId,
      required this.conversations,
      required this.onNewConversationTap,
      required this.onConversationTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Conversations',
                style: AppTextStyles.title.copyWith(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('New Conversation'),
                  onTap: onNewConversationTap,
                ),
                const Divider(),
                ...conversations.map((conv) {
                  return ListTile(
                    leading: Icon(Icons.chat_bubble_outline),
                    title: Text(conv['name']),
                    selected: conversationId == conv['id'],
                    selectedTileColor: Theme.of(context).primaryColorLight,
                    onTap: () => onConversationTap(conv['id']),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
