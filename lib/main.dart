import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/navigation_container.dart';
import 'package:upoint/theme/dark_theme.dart';
import 'package:upoint/theme/light_theme.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AddPostPageBloc(),
            ),
            ChangeNotifierProvider(
              create: (context) => AuthMethods(),
            ),
          ],
          child: Builder(builder: (context) {
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
          })
          ),
    );
  }
}
