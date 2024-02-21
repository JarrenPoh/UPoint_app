import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:upoint/bloc/inbox_page_bloc.dart';
import 'package:upoint/bloc/uri_bloc.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/user_simple_preference.dart';
import 'package:upoint/navigation_container.dart';
import 'package:upoint/theme/dark_theme.dart';
import 'package:upoint/theme/light_theme.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  await initializeDateFormatting('zh', null);
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await Firebase.initializeApp();
  await UserSimplePreference.init();
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
