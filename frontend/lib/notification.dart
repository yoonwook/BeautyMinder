import 'package:beautyminder/pages/calendar_page.dart';
import 'package:beautyminder/pages/recommend_bloc_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Add a GlobalKey for navigation
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification
    ].request();
  }




  static init() async {

    getPermission();

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      _navigateToRoutinePage(); // Call the navigation function
    });
  }

  static requestNotificationPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static void _navigateToRoutinePage() {
    // Use the navigatorKey to navigate
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => CalendarPage(), // Replace with your actual page
    ));
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.max,
            showWhen: false);

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

    await flutterLocalNotificationsPlugin.show(
        0, 'test title', 'test body', notificationDetails);
  }

  static Future<void> showNotification_time(String title, String description, tz.TZDateTime date) async {




    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.max,
            showWhen: false);

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

    flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        title,
        description,
        date,
       //tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
        //makeDate(15, 40, 00),
        NotificationDetails(
            android: androidNotificationDetails,
            iOS: DarwinNotificationDetails(badgeNumber: 1)),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static makeDate(int hour, int min, int sec) {
    var seoul = tz.getLocation('Asia/Seoul');

    var now = tz.TZDateTime.now(seoul);
    tz.TZDateTime when =
        tz.TZDateTime(seoul, now.year, now.month, now.day, hour, min, sec);
    print("now : ${now.toString()}");
    if (when.isBefore(now)) {
      print("내일로 설정");
      return when.add(Duration(days: 1));
    } else {
      print("오늘로 설정");
      print(when.toString());
      return when;
    }
  }

//
//   static tz.TZDateTime _setNotiTime({
//     required DateTime date,
// }){
//
//   }
}
