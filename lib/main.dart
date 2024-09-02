import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:upoint/bloc/inbox_page_bloc.dart';
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
import 'bloc/organizer_fetch_bloc.dart';
import 'bloc/post_fetch_bloc.dart';

late List<CameraDescription> _cameras;
Uri? uri = Uri();

Future<void> main() async {
  await initializeDateFormatting('zh', null);
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await Firebase.initializeApp();
  await UserSimplePreference.init();
  await setupFlutterNotifications();
  await initDynamicLink();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthMethods()),
        ChangeNotifierProvider(create: (context) => InboxPageBloc()),
        ChangeNotifierProvider(create: (context) => OrganzierFetchBloc()),
        ChangeNotifierProvider(create: (context) => PostFetchBloc()),
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
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: NavigationContainer(uri: uri),
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> initDynamicLink() async {
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
  if (initialLink != null) {
    uri = initialLink.link;
    // final Uri deepLink = initialLink.link;
    // if (deepLink.path == "/post") {
    //   final String? postId = deepLink.queryParameters['postId'];
    //   if (postId != null) {
    //     PostModel _p = await FirestoreMethods().fetchPostById(postId);
    //     Get.to(
    //       () => PostDetailPage(
    //         post: _p,
    //         hero: "post${DateTime.now()}",
    //       ),
    //     );
    //   }
    // }
  }
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
    uri = dynamicLinkData.link;
    // if (dynamicLinkData.link.path == "/post") {
    //   final String? postId = dynamicLinkData.link.queryParameters['postId'];
    //   if (postId != null) {
    //     PostModel _p = await FirestoreMethods().fetchPostById(postId);
    //     Get.to(
    //       () => PostDetailPage(
    //         post: _p,
    //         hero: "post${DateTime.now()}",
    //       ),
    //     );
    //   }
    // }
  });
}

Future<void> setupFlutterNotifications() async {
  //flutter local notification setup
  await flutterLocalSetup();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  //允許接收
  FirebaseMessaging.instance.requestPermission();
  //拿token
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("fcm :$fcmToken");
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
  dynamicLinks.onLink.listen((event) async {
    debugPrint('firebas dynamic link: ${event.link}');
    uri = event.link;
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
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      priority: Priority.high,
    );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
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

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
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
