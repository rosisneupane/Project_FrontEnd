class ScheduleItem {
  final String id;
  final String userId;
  final String date;
  final String time;
  final String text;
  final bool status;

  ScheduleItem({
    required this.id,
    required this.userId,
    required this.date,
    required this.time,
    required this.text,
    required this.status,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'],
      userId: json['user_id'],
      date: json['date'],
      time: json['time'],
      text: json['text'],
      status: json['status'],
    );
  }
}
