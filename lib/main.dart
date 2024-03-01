import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:upoint/bloc/inbox_page_bloc.dart';
import 'package:upoint/bloc/uri_bloc.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/user_simple_preference.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/navigation_container.dart';
import 'package:upoint/pages/post_detail_page.dart';
import 'package:upoint/theme/dark_theme.dart';
import 'package:upoint/theme/light_theme.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

late List<CameraDescription> _cameras;
Uri? uri = Uri();

Future<void> main() async {
  await initializeDateFormatting('zh', null);
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await Firebase.initializeApp();
  await UserSimplePreference.init();
  await setupFlutterNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthMethods()),
        ChangeNotifierProvider(create: (context) => UriBloc()),
        ChangeNotifierProvider(create: (context) => InboxPageBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const NavigationContainer(),
      // builder: (context, child) {
      //   // 根据当前主题明暗来设置状态栏样式
      //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      //   SystemChrome.setSystemUIOverlayStyle(
      //     isDarkMode
      //         ? SystemUiOverlayStyle.light.copyWith(
      //             statusBarIconBrightness: Brightness.light, // 暗黑模式下，状态栏图标为亮色
      //             statusBarBrightness: Brightness.dark, // iOS上的状态栏背景为暗色
      //           )
      //         : SystemUiOverlayStyle.dark.copyWith(
      //             statusBarIconBrightness: Brightness.dark, // 明亮模式下，状态栏图标为暗色
      //             statusBarBrightness: Brightness.light, // iOS上的状态栏背景为亮色
      //           ),
      //   );
      //   return child!;
      // },
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> setupFlutterNotifications() async {
  //flutter local notification setup
  await flutterLocalSetup();
  //允許接收
  FirebaseMessaging.instance.requestPermission();
  //拿token
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  await UserSimplePreference.setFcmToken(fcmToken ?? '');

  //接收fcm
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _firebaseMessagingForgroundHandler(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    debugPrint('正在打開mesenger: ${message.data}');
    if (message.data.isNotEmpty) {
      uri = Uri.parse(message.data['open_link']);
      debugPrint('notification open_link: $uri');
      if (uri != null && uri?.pathSegments != null) {
        if (uri!.pathSegments.isNotEmpty &&
            uri!.pathSegments.first == 'activity') {
          final postId = uri!.queryParameters['id'];
          PostModel _p = await FirestoreMethods().fetchPostById(postId);
          Get.to(
            () => PostDetailPage(
              post: _p,
              hero: "activity${DateTime.now()}",
            ),
          );
        } else if (uri!.pathSegments.isNotEmpty &&
            uri!.pathSegments.first == 'users') {
          // final userId = uri.queryParameters['id'];
          // Get.to(
          //   () => ProfileScreen(
          //     searchUserUid: userId!,
          //     hiddenDrawer: false,
          //   ),
          // );
        }
      }
    }
  });

  // uriLinkStream.listen((_uri) {
  //   debugPrint('收到: $_uri');
  //   if (_uri != null) {
  //     uri = _uri;
  //   }
  // });
}

//背景執行
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('背景下收到notification');

  //

  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
}

//前景收到fcm
void _firebaseMessagingForgroundHandler(RemoteMessage message) async {
  try {
    //showsnackbar
    debugPrint("前景下收到data: ${message.data}");
    debugPrint("前景下收到notification: ${message.notification}");
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDetails = const DarwinNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // 通知 ID
      message.notification?.title, // 通知标题
      message.notification?.body, // 通知内容
      generalNotificationDetails, // 通知细节
      payload: message.data["open_link"],
    );
  } catch (e) {
    debugPrint("error:${e.toString()}");
  }
}

Future flutterLocalSetup() async {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse:
        onDidReceiveNotificationResponse,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
}

//  背景或前景點擊notification
void onDidReceiveNotificationResponse(
    NotificationResponse? notificationResponse) async {
  if (notificationResponse != null) {
    Uri uri = Uri.parse(notificationResponse.payload!);
    debugPrint('notification payload: $uri');
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'activity') {
      final postId = uri.queryParameters['id'];
      PostModel _p = await FirestoreMethods().fetchPostById(postId);
      Get.to(
        () => PostDetailPage(
          post: _p,
          hero: "activity${DateTime.now()}",
        ),
      );
    } else if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'users') {
      // final userId = uri.queryParameters['id'];
      // Get.to(
      //   () => ProfileScreen(
      //     searchUserUid: userId!,
      //     hiddenDrawer: false,
      //   ),
      // );
    }
  }
}
