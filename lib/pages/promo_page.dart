import 'package:flutter/material.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    return Scaffold(
      body: Center(
        child: Text(
          'Promo Page',
          style: TextStyle(
            color: onSecondary,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
