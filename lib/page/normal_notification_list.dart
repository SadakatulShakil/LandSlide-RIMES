import 'package:flutter/material.dart';

class NormalNotificationList extends StatelessWidget {
  const NormalNotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller
    return Scaffold(
      body: Center(
        child: Text('This is the general page.',
            style: TextStyle(color: Colors.blue, fontSize: 20)),
      ),
    );
  }

}