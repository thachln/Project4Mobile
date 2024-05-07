import 'package:pj4mb/models/Notification/NotificationType.dart';

class NotificationDTO{
  final int id;
  late int userId;
  final NotificationType notificationType;
  final int eventId;
  final String message;
  final bool read;
  final DateTime timestamp;

  NotificationDTO({required this.id, required this.userId, required this.notificationType, required this.eventId, required this.message, required this.read, required this.timestamp});


  NotificationDTO.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        notificationType = NotificationType.values.firstWhere((e) => e.toString() == 'NotificationType.'+json['notificationType']),
        eventId = json['eventId'],
        message = json['message'],
        read = json['read'],
        timestamp = DateTime.parse(json['timestamp']);


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['notificationType'] = this.notificationType.toString().split('.').last;
    data['eventId'] = this.eventId;
    data['message'] = this.message;
    data['read'] = this.read;
    data['timestamp'] = this.timestamp;
    return data;
  }
}