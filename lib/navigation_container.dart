import 'package:flutter/material.dart';
import 'package:upoint/pages/home_page.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({super.key});

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
