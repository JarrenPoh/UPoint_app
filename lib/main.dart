import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
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
        ChangeNotifierProvider(create: (_) => AddPostPageBloc()),
        ChangeNotifierProvider(create: (context) => AuthMethods()),
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
      home: Builder(
        builder: (context) {
          bool isOrganizer = false;
          if (FirebaseAuth.instance.currentUser != null) {
            String email = FirebaseAuth.instance.currentUser!.email!;
            if (email == "jjpohhh@gmail.com") {
              isOrganizer = true;
            }
          }
          return NavigationContainer(
            uri: null,
            isOrganizer: isOrganizer,
          );
        },
      ),
    );
  }
}
