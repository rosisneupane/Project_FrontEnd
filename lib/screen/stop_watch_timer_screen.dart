import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class CountdownTimerScreen extends StatefulWidget {
  const CountdownTimerScreen({super.key});

  @override
  State<CountdownTimerScreen> createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  Duration initialDuration = const Duration(minutes: 1);
  Duration remaining = const Duration(minutes: 1);
  Timer? timer;
  bool isRunning = false;

  int selectedHours = 0;
  int selectedMinutes = 1;
  int selectedSeconds = 0;

  void startTimer() {
    if (remaining.inSeconds > 0 && !isRunning) {
      isRunning = true;
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (remaining.inSeconds > 0) {
          setState(() {
            remaining -= const Duration(seconds: 1);
          });
        } else {
          stopTimer();
          _showFinishedDialog();
        }
      });
    }
  }

  void stopTimer() {
    timer?.cancel();
    isRunning = false;
    setState(() {});
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      remaining = initialDuration;
    });
  }

  void pickDuration() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 300,
        child: Row(
          children: [
            _buildPicker("Hours", 24, selectedHours, (value) {
              selectedHours = value;
            }),
            _buildPicker("Minutes", 60, selectedMinutes, (value) {
              selectedMinutes = value;
            }),
            _buildPicker("Seconds", 60, selectedSeconds, (value) {
              selectedSeconds = value;
            }),
          ],
        ),
      ),
    );

    final newDuration = Duration(
      hours: selectedHours,
      minutes: selectedMinutes,
      seconds: selectedSeconds,
    );

    if (newDuration.inSeconds > 0) {
      stopTimer();
      setState(() {
        initialDuration = newDuration;
        remaining = newDuration;
      });
    }
  }

  Widget _buildPicker(String label, int max, int initialValue, Function(int) onSelected) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: FixedExtentScrollController(initialItem: initialValue),
              onSelectedItemChanged: onSelected,
              children: List.generate(max, (index) => Center(child: Text(index.toString().padLeft(2, '0')))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  void _showFinishedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Time's up!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetTimer();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Countdown Timer', style: AppTextStyles.question),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatDuration(remaining),
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? stopTimer : startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: pickDuration,
              child: const Text(
                'Set Time',
                style: TextStyle(fontSize: 18, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
