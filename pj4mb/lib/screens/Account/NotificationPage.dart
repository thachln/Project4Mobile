import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Notification/Notification.dart';
import 'package:pj4mb/services/Notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.listNotification});
  final List<NotificationDTO> listNotification;
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<NotificationDTO> listNoti;
  @override
  void initState() {
    super.initState();
    listNoti = widget.listNotification;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
        actions: [
          TextButton(
              onPressed: () async {
                var notRead = widget.listNotification
                    .where((element) => element.read == false)
                    .toList();

                for (var element in notRead) {
                  element.read = true;
                  await NotificationService().UpdateNotification(element);
                }
                var data = await NotificationService().GetNotification();
                setState(() {
                  listNoti = data;
                });
              },
              child: Text('Mark all as read'))
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: listNoti.length,
          itemBuilder: (context, index) {
            var notification = listNoti[index];
            return Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () async {
                  notification.read = true;
                  var result = await NotificationService()
                      .UpdateNotification(notification);

                  if (result) {
                    var data = await NotificationService().GetNotification();
                    setState(() {
                      listNoti = data;
                    });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        notification.message +
                            " - " +
                            DateFormat("dd-MM-yyyy HH:mm:ss")
                                .format(notification.timestamp),
                        style: notification.read
                            ? TextStyle(color: Colors.grey)
                            : TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
