import 'package:flutter/material.dart';
import 'package:new_ui/services/user_score_service.dart';
import 'package:new_ui/user_services.dart';

class JobInterviewRoleplayScreen extends StatefulWidget {
  const JobInterviewRoleplayScreen({super.key});

  @override
  State<JobInterviewRoleplayScreen> createState() =>
      _JobInterviewRoleplayScreenState();
}

class _JobInterviewRoleplayScreenState
    extends State<JobInterviewRoleplayScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;

  final List<Map<String, dynamic>> _questions = [
    {
      'scenario': '🌟 Question 1: Talking About Yourself',
      'question': 'You\'re asked, "Can you tell me a little about yourself?"',
      'options': [
        'I\'m a high school student who loves working in teams and solving problems.',
        'I don\'t know… I\'m just average.',
        'I\'m not really sure what to say. I just want a job.',
      ],
      'feedback': [
        '✅ Great start! Clear, confident, and positive.',
        '❌ Selling yourself short — you have strengths!',
        '❌ Shows a lack of preparation and interest.',
      ],
    },
    {
      'scenario': '🌟 Question 2: Interests and Hobbies',
      'question': 'They ask, "What are your interests or hobbies?"',
      'options': [
        'I love drawing and working on creative projects.',
        'Nothing really, I mostly scroll through my phone.',
        'I used to be interested in stuff, but not anymore.',
      ],
      'feedback': [
        '✅ Shows creativity and passion — well done!',
        '❌ Sounds disengaged — try highlighting something productive.',
        '❌ Negativity can turn employers off.',
      ],
    },
    {
      'scenario': '🌟 Question 3: Being Social',
      'question': 'They ask, "Would you describe yourself as a social person?"',
      'options': [
        'I’m friendly and approachable, but I also respect others\' space.',
        'I don’t really like people.',
        'I only talk to others if I have to.',
      ],
      'feedback': [
        '✅ Balanced and mature — good teamwork vibes!',
        '❌ Workplaces value collaboration.',
        '❌ Limited social engagement can be concerning.',
      ],
    },
    {
      'scenario': '🌟 Question 4: Teamwork Example',
      'question': 'Can you give an example of working with others on a team?',
      'options': [
        'I helped organize a school group project and kept everyone on track.',
        'I prefer to work alone — group work is annoying.',
        'I usually let others lead. I just follow.',
      ],
      'feedback': [
        '✅ Demonstrates leadership and responsibility!',
        '❌ Negative attitude toward teamwork.',
        '❌ Shows a lack of initiative.',
      ],
    },
    {
      'scenario': '🌟 Question 5: Motivation to Work There',
      'question': 'Why do you want to work here?',
      'options': [
        'I like the positive atmosphere and I want to learn customer service skills.',
        'Because I need money.',
        'My parents made me apply.',
      ],
      'feedback': [
        '✅ Shows enthusiasm and a growth mindset!',
        '❌ Money is important, but employers want more motivation.',
        '❌ Lack of personal interest could be a deal-breaker.',
      ],
    },
    {
      'scenario': '🌟 Question 6: Handling Stress',
      'question': 'How do you manage responsibilities when stressed?',
      'options': [
        'I write a list and prioritize tasks.',
        'I just avoid everything until it goes away.',
        'I freak out and forget stuff.',
      ],
      'feedback': [
        '✅ Organized and resilient — employers love that!',
        '❌ Avoidance doesn\'t solve problems.',
        '❌ Emotional control is key under pressure.',
      ],
    },
    {
      'scenario': '🌟 Question 7: Availability',
      'question': 'Are you available evenings and weekends?',
      'options': [
        'Yes, after 4 pm on weekdays and weekends are good.',
        'Only if I don’t have homework or plans.',
        'I can’t promise anything.',
      ],
      'feedback': [
        '✅ Clear and reliable availability — excellent!',
        '❌ Uncertainty can be a red flag.',
        '❌ Commitment matters in a job.',
      ],
    },
    {
      'scenario': '🌟 Question 8: Problem Solving',
      'question': 'Tell me about a time you helped solve a problem.',
      'options': [
        'I made a checklist for our morning routine to help my family be on time.',
        'I just avoid conflicts.',
        'I don’t really deal with problems.',
      ],
      'feedback': [
        '✅ Proactive problem-solver — huge plus!',
        '❌ Avoidance doesn\'t impress managers.',
        '❌ Shows lack of initiative.',
      ],
    },
    {
      'scenario': '🌟 Question 9: Handling Uncooperative Coworkers',
      'question': 'What would you do if a coworker wasn’t doing their part?',
      'options': [
        'I’d politely ask if they need help and then follow up if needed.',
        'I’d just do the work myself.',
        'I’d complain to others.',
      ],
      'feedback': [
        '✅ Shows leadership and respect!',
        '❌ Doing everything yourself isn\'t sustainable.',
        '❌ Gossiping damages team morale.',
      ],
    },
    {
      'scenario': '🌟 Question 10: Self-Pitch',
      'question': 'Why should we hire you?',
      'options': [
        'I\'m hardworking, respectful, and excited to learn.',
        'I don\'t know. I just need a job.',
        'I guess I\'m okay.',
      ],
      'feedback': [
        '✅ Positive, confident, and genuine!',
        '❌ Shows lack of passion or preparation.',
        '❌ Low confidence can be a concern.',
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
        title: const Text('Job interview Role play'),
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
