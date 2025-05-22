import 'package:flutter/material.dart';

class AlertNotificationList extends StatelessWidget {
  const AlertNotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is the alert page.', style: TextStyle(color: Colors.teal, fontSize: 20)),
      ),
    );
  }
}