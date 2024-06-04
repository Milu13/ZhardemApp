import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zhardem/widgets/saveElevatedButton.dart';

class TimerActionButton extends StatefulWidget {
  final int initialSeconds;
  final Function()? onButtonPressed;

  const TimerActionButton({
    Key? key,
    required this.initialSeconds,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  _TimerActionButtonState createState() => _TimerActionButtonState();
}

class _TimerActionButtonState extends State<TimerActionButton> {
  late Timer _timer;
  late int _seconds;
  bool _timerActive = true;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_seconds == 0) {
          _timer.cancel();
          _timerActive = false;
        } else {
          _seconds--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
            child: _timerActive
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Повторно отправить код можно через ',
                  style:  TextStyle(fontSize: 18),
                ) ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_seconds ',
                      style: TextStyle(
                        fontSize: 18,
                        color: _seconds < 10 ? Colors.red : Colors.black,
                      ),
                    ),
                    const  Text(
                      'сек.',
                      style:  TextStyle(fontSize: 18),
                    ),
                  ],
                ),


              ],
            )
                : SaveElevatedButton(
                height: 50,
                text: "Отправить код еще раз",
                onPressed: (){
                  setState(() {
                    _seconds = widget.initialSeconds;
                    _timerActive = true;
                    startTimer();
                  });
                  widget.onButtonPressed?.call();
                })
        ),
      ],
    );
  }
}

