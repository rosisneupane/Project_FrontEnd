import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/screen/scheduledetail_screen.dart';
import 'package:intl/intl.dart';

class ScheduleCard extends StatelessWidget {
  final String id;
  final String date;
  final String time;
  final String text;
  final bool status;

  const ScheduleCard({
    super.key,
    required this.id,
    required this.date,
    required this.time,
    required this.text,
    required this.status,
  });

  String _formatDate() {
    try {
      final dateTime = DateTime.parse('${date}T$time');
      return DateFormat('yyyy-MM-dd').format(dateTime.toLocal());
    } catch (e) {
      return date;
    }
  }

  String _formatTime() {
    try {
      final dateTime = DateTime.parse('${date}T$time');
      return DateFormat('hh:mm a').format(dateTime.toLocal());
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleDetailPage(
                id: id,
                date: date,
                time: time,
                text: text,
                status: status,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 110,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(),
                              style: const TextStyle(
                                color: Color(0xFF3F3B35),
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.05,
                              ),
                            ),
                            Text(
                              _formatTime(),
                              style: const TextStyle(
                                color: Color(0xFF3F3B35),
                                fontSize: 12,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.03,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          text,
                          style: const TextStyle(
                            color: Color(0xFF3F3B35),
                            fontSize: 10,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      status ? 'Done' : 'Not Done',
                      style: const TextStyle(
                        color: Color(0xFF3F3B35),
                        fontSize: 8,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.02,
                      ),
                    )
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: SvgPicture.asset(
                  'assets/images/Female.svg',
                  width: 150,
                  height: 113,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
