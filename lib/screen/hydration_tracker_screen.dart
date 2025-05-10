import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class HydrationTrackerScreen extends StatefulWidget {
  const HydrationTrackerScreen({super.key});

  @override
  State<HydrationTrackerScreen> createState() => _HydrationTrackerScreenState();
}

class _HydrationTrackerScreenState extends State<HydrationTrackerScreen> {
  double dailyGoal = 3.0;
  double currentIntake = 0.0;

  @override
  void initState() {
    super.initState();
    _loadHydrationData();
  }

  Future<void> _loadHydrationData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyGoal = prefs.getDouble('dailyGoal') ?? 2.0;
      currentIntake = prefs.getDouble('currentIntake') ?? 0.0;
    });
  }

  Future<void> _saveHydrationData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('dailyGoal', dailyGoal);
    await prefs.setDouble('currentIntake', currentIntake);
  }

  void setDailyGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double tempGoal = dailyGoal;
        return AlertDialog(
          title: const Text('Set Daily Goal (Liters)'),
          content: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: "e.g. 2.5"),
            onChanged: (val) {
              tempGoal = double.tryParse(val) ?? dailyGoal;
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  dailyGoal = tempGoal;
                  if (currentIntake > dailyGoal) currentIntake = dailyGoal;
                });
                _saveHydrationData();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void logWaterIntake() {
    showDialog(
      context: context,
      builder: (context) {
        double intake = 0.0;
        return AlertDialog(
          title: const Text('Water Intake (Liters)'),
          content: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: "e.g. 0.3"),
            onChanged: (val) {
              intake = double.tryParse(val) ?? 0.0;
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentIntake += intake;
                  if (currentIntake > dailyGoal + 1.0) {
                    currentIntake = dailyGoal + 1.0;
                  }
                });
                _saveHydrationData();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void resetIntake() async {
    setState(() {
      currentIntake = 0.0;
    });
    await _saveHydrationData();
  }

  String getFeedbackMessage() {
    final progress = currentIntake / dailyGoal;
    if (progress < 0.5) {
      return "Keep going, you need more water!";
    } else if (progress >= 0.5 && progress <= 1.0) {
      return "Nice! You're staying hydrated.";
    } else {
      return "Too much! Watch your intake.";
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIntake / dailyGoal).clamp(0.0, 1.0);
    double remaining = (dailyGoal - currentIntake).clamp(0.0, dailyGoal);
    String feedback = getFeedbackMessage();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Hydration Tracker', style: AppTextStyles.question),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${currentIntake.toStringAsFixed(2)} / ${dailyGoal.toStringAsFixed(2)} L',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: AppColors.primary,
              minHeight: 20,
            ),
            const SizedBox(height: 20),
            Text(
              'Remaining: ${remaining.toStringAsFixed(2)} L',
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Text(
              feedback,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: logWaterIntake,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Log Intake"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: setDailyGoalDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade400,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Set Daily Goal"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetIntake,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
