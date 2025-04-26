import 'package:flutter/material.dart';
import 'package:new_ui/services/user_score_service.dart';
import 'package:new_ui/user_services.dart';

class SocialScenarioPage extends StatefulWidget {
  const SocialScenarioPage({super.key});

  @override
  State<SocialScenarioPage> createState() => _SocialScenarioPageState();
}

class _SocialScenarioPageState extends State<SocialScenarioPage> {
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;

  final List<Map<String, dynamic>> _questions = [
    {
      'scenario': '🌟 Scenario 1: Introducing Yourself to Someone New',
      'question':
          'You’ve joined a new school club. Someone is sitting next to you. What do you do?',
      'options': [
        '“Hi, I’m ${UserService().user!.username}. What’s your name?”',
        'Sit quietly and wait for them to speak first.',
        '“I hate small talk. Let’s just get this over with.”',
      ],
      'feedback': [
        '✅ Nice! That’s a friendly and confident way to start a conversation.',
        '⚠️ It\'s okay to feel shy, but taking the first step shows confidence.',
        '❌ That might come off as rude. A simple greeting goes a long way.',
      ],
    },
    {
      'scenario': '🌟 Scenario 2: Someone Made a Mistake in a Group Project',
      'question':
          'Your classmate made a small mistake in your group presentation. How do you react?',
      'options': [
        '“That’s okay! We can fix it together.”',
        'Roll your eyes and fix it without saying anything.',
        '“You always mess things up.”',
      ],
      'feedback': [
        '✅ That’s teamwork! Being kind helps everyone feel safe.',
        '⚠️ Fixing it is helpful, but letting them know kindly would be better.',
        '❌ That could hurt their feelings and damage the group trust.',
      ],
    },
    {
      'scenario': '🌟 Scenario 3: You’re Feeling Left Out',
      'question':
          'You see your friends hanging out without inviting you. What do you do?',
      'options': [
        'Ask them later, “Hey, I saw you guys out. Can I join next time?”',
        'Post a passive-aggressive message on your story.',
        'Stop talking to them altogether.',
      ],
      'feedback': [
        '✅ Open communication is brave and respectful.',
        '⚠️ That might make things worse. Talking directly is better.',
        '❌ Avoiding the situation might leave things unresolved.',
      ],
    },
    {
      'scenario': '🌟 Scenario 4: A Friend Seems Upset',
      'question': 'Your friend is unusually quiet today. What do you say?',
      'options': [
        '“Are you okay? I’m here if you want to talk.”',
        'Ignore it – it’s probably nothing.',
        '“You look terrible today, what happened?”',
      ],
      'feedback': [
        '✅ That shows you care and creates a safe space.',
        '⚠️ Sometimes silence is fine, but reaching out shows you’re a good friend.',
        '❌ That might make them feel worse. Be gentle and supportive.',
      ],
    },
    {
      'scenario': '🌟 Scenario 5: You Disagree in a Group Chat',
      'question':
          'In your friend group chat, someone says something you strongly disagree with. What do you do?',
      'options': [
        'Calmly say, “I see it differently. Can we talk about it?”',
        'Leave the group chat immediately.',
        'Reply in all caps: “THAT’S THE DUMBEST THING EVER.”',
      ],
      'feedback': [
        '✅ You’re expressing yourself respectfully — great conflict resolution!',
        '⚠️ That avoids the issue. It’s better to talk things out.',
        '❌ That’s aggressive and could hurt your friendships.',
      ],
    },
    {
      'scenario': '🌟 Scenario 6: Making a Phone Call',
      'question':
          'You need to call your doctor to reschedule an appointment. You feel nervous. What do you do?',
      'options': [
        'Write down what you want to say and then call.',
        'Keep putting it off and hope someone else does it.',
        'Call and mumble, “uhh… I need to change… something…”',
      ],
      'feedback': [
        '✅ Preparation builds confidence. Great strategy!',
        '⚠️ Avoiding it might increase your stress. Taking action feels better.',
        '❌ Being unclear can cause confusion. Practicing first helps!',
      ],
    },
    {
      'scenario': '🌟 Scenario 7: Asking for Help in Class',
      'question':
          'You’re lost in class but don’t want to look dumb. What should you do?',
      'options': [
        'Raise your hand and say, “Can you explain that again?”',
        'Pretend you understand and figure it out later.',
        'Whisper to your classmate, “This is stupid.”',
      ],
      'feedback': [
        '✅ Asking questions shows courage and curiosity!',
        '⚠️ It’s okay sometimes, but confusion can build up.',
        '❌ That could sound disrespectful. Try to stay positive.',
      ],
    },
    {
      'scenario': '🌟 Scenario 8: Complimenting Someone',
      'question': 'You like someone’s art project. How do you tell them?',
      'options': [
        '“Hey, I really like your artwork — it’s so creative!”',
        'Say nothing — they probably get enough compliments.',
        '“It’s nice... I guess.”',
      ],
      'feedback': [
        '✅ Genuine compliments can make someone’s day!',
        '⚠️ Holding back kindness is a missed opportunity.',
        '❌ That might sound unsure or dismissive.',
      ],
    },
    {
      'scenario': '🌟 Scenario 9: Dealing With Peer Pressure',
      'question': 'Your friend dares you to skip class. What do you say?',
      'options': [
        '“No thanks — I’d rather not get into trouble.”',
        '“Okay, but just this once.”',
        '“Sure, whatever.”',
      ],
      'feedback': [
        '✅ Setting boundaries takes strength. Great choice!',
        '⚠️ Sometimes we give in — but next time, try standing your ground.',
        '❌ Saying yes without thinking can lead to regret.',
      ],
    },
    {
      'scenario': '🌟 Scenario 10: Joining a New Club',
      'question':
          'You want to join a new school club, but you’re nervous. What do you do?',
      'options': [
        'Attend and say, “Hi, I’m new here.”',
        'Wait outside the door, then go home.',
        'Message the club leader: “This is dumb, I’m out.”',
      ],
      'feedback': [
        '✅ Taking the first step is brave — well done!',
        '⚠️ That’s okay — maybe next time, just step in slowly.',
        '❌ That burns a bridge. Stay open to trying new things.',
      ],
    },
  ];

  void _selectOption(int index) {
    setState(() {
      _selectedOptionIndex = index;

            // If it's the last question, call _onFinished
      if (_currentQuestionIndex == _questions.length - 1) {
        UserScoreService.updateUserScore(UserService().user!.score + 100);
      }
    });
  }

  void _goToNextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _selectedOptionIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Scenarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(current['scenario'], style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text(current['question'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ...List.generate(current['options'].length, (index) {
              final isSelected = _selectedOptionIndex == index;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ElevatedButton(
                  onPressed: _selectedOptionIndex == null
                      ? () => _selectOption(index)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.orange : Colors.grey.shade300,
                    foregroundColor: isSelected ? Colors.white : Colors.black87,
                  ),
                  child: Text(current['options'][index]),
                ),
              );
            }),
            const SizedBox(height: 24),
            if (_selectedOptionIndex != null)
              Text(
                current['feedback'][_selectedOptionIndex!],
                style: const TextStyle(fontSize: 16),
              ),
            const Spacer(),
            if (_selectedOptionIndex != null &&
                _currentQuestionIndex < _questions.length - 1)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _goToNextQuestion,
                  child: const Text('Next'),
                ),
              ),
            if (_currentQuestionIndex == _questions.length - 1 &&
                _selectedOptionIndex != null)
              const Center(
                child: Text(
                  '🎉 You’ve completed all the scenarios!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
