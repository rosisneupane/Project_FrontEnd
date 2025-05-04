import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<String> _questions = [
    'I feel sad, empty, or hopeless most days.',
    'I often feel anxious or on edge, even without a clear reason.',
    'I have difficulty finding joy in things I used to enjoy.',
    'I feel emotionally exhausted or drained, even after rest.',
    'I avoid emotional closeness or push others away.',
    'I have trouble managing my emotions when stressed.',
    'I feel lonely even when I’m around others.',
    'I constantly worry about things going wrong.',
    'I find it hard to trust others, even when they mean well.',
    'I understand how I feel and why, most of the time.',
  ];

  final Map<int, int> _answers = {};
  final List<String> _scaleLabels = ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'];
  int _currentQuestionIndex = 0;

  void _nextQuestion() {
    if (_answers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer before proceeding.')),
      );
      return;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    int totalScore = _answers.values.fold(0, (sum, val) => sum + val);
    _showResultDialog(totalScore);
  }

  void _showResultDialog(int score) {
    String insight;
    String suggestion;

    if (score <= 10) {
      insight = 'You seem emotionally balanced.';
      suggestion = 'Keep practicing self-care.';
    } else if (score <= 20) {
      insight = 'Mild symptoms, possible early signs.';
      suggestion = 'Try journaling and explore our meditation modules.';
    } else if (score <= 30) {
      insight = 'Moderate concerns in multiple areas.';
      suggestion = 'Consider using our guided therapy tools and check-ins.';
    } else {
      insight = 'High distress likely.';
      suggestion = 'We recommend speaking to a therapist and reviewing crisis resources.';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Your Emotional Insight'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score: $score / 40', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(insight, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(suggestion),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _answers.clear();
              });
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Emotional Wellness Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Q${_currentQuestionIndex + 1}. $question',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ...List.generate(5, (i) {
                  return RadioListTile<int>(
                    value: i,
                    groupValue: _answers[_currentQuestionIndex],
                    onChanged: (val) {
                      setState(() {
                        _answers[_currentQuestionIndex] = val!;
                      });
                    },
                    title: Text(_scaleLabels[i]),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _nextQuestion,
          child: Text(
            _currentQuestionIndex == _questions.length - 1 ? 'Submit' : 'Next',
          ),
        ),
      ),
    );
  }
}
