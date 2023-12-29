import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
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
        ],
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.hasData) {
              print('data: ${snapshot.data}');
              String email = FirebaseAuth.instance.currentUser!.email!;
              bool isOrganizer = false;
              if (email == "jjpohhh@gmail.com") {
                isOrganizer = true;
              }
              return NavigationContainer(
                uri: null,
                isOrganizer: isOrganizer,
              );
            } else {
              return const NavigationContainer(
                uri: null,
                isOrganizer: false,
              );
            }
          },
        ),
      ),
    );
  }
}
