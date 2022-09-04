import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async{
    try {
      print("In Notification method");
      // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
      Random random = new Random();
      int id = random.nextInt(1000);
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "mychanel",
            "my chanel",
            importance: Importance.max,
            priority: Priority.high,
          )

      );
      print("my id is ${id.toString()}");
      await _flutterLocalNotificationsPlugin.show(

        id,
        message.notification!.title,
        message.notification!.title,
        notificationDetails,);
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }

// creating notification
//  sendNotification(String title, String token)async{
//     final data = {
//       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//       'id': '1',
//       'status': 'done',
//       'message': title,
//     };
//     try{
//      http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'key=ADD-YOUR-SERVER-KEY-HERE'
//       },
//       body: jsonEncode(<String,dynamic>{
//         'notification': <String,dynamic> {'title': title,'body': 'You are followed by someone'},
//         'priority': 'high',
//         'data': data,
//         'to': '$token'
//       })
//       );
//      if(response.statusCode == 200){
//        print("Yeh notificatin is sended");
//      }else{
//        print("Error");
//      }
//     }catch(e){
//     }
//   }

}