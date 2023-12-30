import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int seconds;
  TimerWidget({super.key, required this.seconds});

  static const maxSec = 5;
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Stack(fit: StackFit.expand, children: [
        CircularProgressIndicator(
          value: seconds / maxSec,
          strokeWidth: 10,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
        ),
        Center(
          child: Text("${seconds}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
      ]),
    );
  }
}
