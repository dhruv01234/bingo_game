import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
class StatusIndicator extends StatelessWidget {
  StatusIndicator({required this.duration,required this.width,required this.height,required this.fontsize,required this.strokewidth,required this.onComplete});
  int duration;
  double width;
  double height;
  double strokewidth;
  double fontsize;
  Function onComplete;
  @override
  Widget build(BuildContext context) {

    return CircularCountDownTimer(
      duration: duration,
      initialDuration: 0,
      ringColor: Colors.grey.shade200,
      width: width,
      height: height,
      ringGradient: null,
      fillColor: Colors.blueAccent,
      fillGradient: null,
      backgroundColor: Colors.white,
      backgroundGradient: null,
      strokeWidth: strokewidth,
      strokeCap: StrokeCap.round,
      textStyle: TextStyle(
          fontSize: fontsize, color: Colors.blueAccent, fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.S,
      isReverse: true,
      isReverseAnimation: true,
      isTimerTextShown: true,
      autoStart: true,
      onComplete: () {
        onComplete();
      },
    );
  }

}