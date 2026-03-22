import 'package:flutter/material.dart';

class QueueTrackingScreen extends StatelessWidget {
  const QueueTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Queue Tracking"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: const [

            Text(
              "Your Token: 23",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Text(
              "Current Token: 19",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "Patients Ahead: 4",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "Estimated Wait: 20 minutes",
              style: TextStyle(fontSize: 18),
            ),

          ],
        ),
      ),
    );
  }
}