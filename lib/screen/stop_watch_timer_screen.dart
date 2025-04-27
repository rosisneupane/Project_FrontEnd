import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class StopwatchTimerScreen extends StatefulWidget {
  const StopwatchTimerScreen({super.key});

  @override
  State<StopwatchTimerScreen> createState() => _StopwatchTimerScreenState();
}

class _StopwatchTimerScreenState extends State<StopwatchTimerScreen> {
  final Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  void startStopwatch() {
    if (!stopwatch.isRunning) {
      stopwatch.start();
      timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (stopwatch.isRunning) {
          setState(() {});
        }
      });
    }
  }

  void stopStopwatch() {
    stopwatch.stop();
    timer?.cancel();
    setState(() {}); // Update UI immediately after stop
  }

  void resetStopwatch() {
    stopwatch.reset();
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(stopwatch.elapsed.inMinutes.remainder(60));
    final seconds = twoDigits(stopwatch.elapsed.inSeconds.remainder(60));
    final centiseconds = twoDigits((stopwatch.elapsedMilliseconds.remainder(1000) ~/ 10));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Focus Timer', style: AppTextStyles.question),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutes:$seconds:$centiseconds',
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
                  onPressed: stopwatch.isRunning ? stopStopwatch : startStopwatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(stopwatch.isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: resetStopwatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
