import 'dart:async';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static const focusTime = 25 * 60;
  static const breakTime = 5 * 60;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AudioPlayer player = AudioPlayer();

  int currentFocusTime = focusTime;
  int currentBreakTime = breakTime;
  String timerType = 'focus';
  Timer? timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();

    player.setReleaseMode(ReleaseMode.stop);
    player.setVolume(0.5);
    player.setSource(AssetSource('audios/alarm.mp3'));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestNotificationPermission();
      await _initializeNotifications();
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showPersistentNotification() async {
    String formattedString =
        formatTime(timerType == 'focus' ? currentFocusTime : currentBreakTime);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'pomodoro_timer_channel',
      'Pomodoro Timer',
      channelDescription: 'Shows timer progress',
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      ongoing: true,
      color: timerType == 'focus'
          ? Color.fromARGB(255, 252, 94, 83)
          : Color.fromARGB(255, 70, 187, 129),
      playSound: false,
      silent: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Time remaining: $formattedString',
      timerType == 'focus' ? 'Keep your focus!' : 'Take a break!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> playAlarm() async {
    await player.resume();
  }

  void startTimer() {
    if (!isRunning) {
      setState(() {
        isRunning = true;
      });

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (timerType == 'focus') {
            currentFocusTime--;

            if (currentFocusTime <= 0) {
              timerType = 'break';
              currentFocusTime = focusTime;
              playAlarm();
            }
          } else {
            currentBreakTime--;
            if (currentBreakTime <= 0) {
              timerType = 'focus';
              currentBreakTime = breakTime;
              playAlarm();
            }
          }
        });

        _showPersistentNotification();
      });
    }
  }

  void stopTimer() {
    if (isRunning) {
      timer?.cancel();
      setState(() {
        isRunning = false;
      });

      _notificationsPlugin.cancel(0);
    }
  }

  String formatTime(int time) {
    final minutes = (time / 60).floor().toString().padLeft(2, '0');
    final seconds = (time % 60).floor().toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  bool get hasStarted {
    if (currentBreakTime < breakTime || currentFocusTime < focusTime) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.fromLTRB(24, 64, 24, 64),
        color: !isRunning
            ? Color.fromARGB(255, 43, 127, 223)
            : timerType == 'focus'
                ? Color.fromARGB(255, 252, 94, 83)
                : Color.fromARGB(255, 70, 187, 129),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  'pomodoro.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white.withAlpha(50),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.thumbtack,
                        color: Colors.white,
                        size: 16,
                      ),
                      const Text(
                        'Create login page',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                Text(
                  !isRunning
                      ? hasStarted
                          ? 'Do not give up!'
                          : "Let's get started!"
                      : timerType == 'focus'
                          ? 'Keep your focus!'
                          : 'Take a break!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  formatTime(timerType == 'focus'
                      ? currentFocusTime
                      : currentBreakTime),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 86,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto Mono',
                  ),
                  textAlign: TextAlign.center,
                ),
                Lottie.asset(
                  'assets/lottie/clock.json',
                  height: 150,
                  repeat: true,
                  animate: isRunning,
                  frameRate: FrameRate(60),
                ),
              ],
            ),
            IconButton(
              onPressed: isRunning ? stopTimer : startTimer,
              icon: isRunning
                  ? FaIcon(FontAwesomeIcons.pause)
                  : FaIcon(FontAwesomeIcons.play),
              color: Colors.white,
              iconSize: 48,
              padding: EdgeInsets.all(16),
            ),
          ],
        ),
      ),
    );
  }
}
