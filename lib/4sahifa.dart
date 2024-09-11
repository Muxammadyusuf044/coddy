import 'dart:async';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Duration _timeLeft = Duration();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    DateTime now = DateTime.now();
    DateTime endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);

    setState(() {
      _timeLeft = endOfYear.difference(now);
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft = endOfYear.difference(DateTime.now());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Yil tugashiga qolgan vaqt",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_timeLeft.inDays} kun',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${_timeLeft.inHours % 24} soat, ',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${_timeLeft.inMinutes % 24} daqiqa, ',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${_timeLeft.inSeconds % 24} sekund, ',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
