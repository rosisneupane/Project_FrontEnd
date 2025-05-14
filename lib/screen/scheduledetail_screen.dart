import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/screen/createschedule_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleDetailPage extends StatefulWidget {
  final String id;
  final String date;
  final String time;
  final String text;
  final bool status;
  final void Function()? onDelete;

  const ScheduleDetailPage({
    super.key,
    required this.id,
    required this.date,
    required this.time,
    required this.text,
    required this.status,
    this.onDelete,
  });

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  late bool currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
  }

  String get formattedDate {
    try {
      final dateTime = DateTime.parse('${widget.date}T${widget.time}');
      return DateFormat('MMMM dd, yyyy').format(dateTime.toLocal());
    } catch (e) {
      return widget.date;
    }
  }

  String get formattedTime {
    try {
      final dateTime = DateTime.parse('${widget.date}T${widget.time}');
      return DateFormat('hh:mm a').format(dateTime.toLocal());
    } catch (e) {
      return widget.time;
    }
  }

  void toggleStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('JWT Token not found');
    }

    final url = Uri.parse('${AppConfig.apiUrl}/routines/${widget.id}');
    final updatedRoutine = {
      "date": widget.date,
      "time": widget.time,
      "text": widget.text,
      "status": !currentStatus
    };

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
      body: jsonEncode(updatedRoutine),
    );

    if (response.statusCode == 200) {
      setState(() {
        currentStatus = !currentStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status updated')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status')),
      );
    }
  }

  void deleteSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('JWT Token not found');
    }
    final url = Uri.parse('${AppConfig.apiUrl}/routines/${widget.id}');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      widget.onDelete?.call();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Routine deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete routine')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateScheduleScreen()));
            },
            tooltip: 'Create New Schedule',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Text:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Date:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Time:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              formattedTime,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Status:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              currentStatus ? 'Done' : 'Not Done',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: currentStatus ? Colors.green : Colors.red,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: toggleStatus,
                  icon: const Icon(Icons.sync),
                  label: const Text('Toggle Status'),
                ),
                ElevatedButton.icon(
                  onPressed: deleteSchedule,
                  icon: const Icon(Icons.delete),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  label: const Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
