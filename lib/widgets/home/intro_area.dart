import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';

class IntroArea extends StatefulWidget {
  const IntroArea({super.key});

  @override
  State<IntroArea> createState() => _IntroAreaState();
}

class _IntroAreaState extends State<IntroArea> {
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;

    return Container(
      color: scaffoldBackgroundColor,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: appBarColor,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width5 * 6,
          vertical: Dimensions.height5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find Your',
              style: TextStyle(
                color: onSecondary,
                fontSize: Dimensions.height5 * 5,
              ),
            ),
            SizedBox(height: Dimensions.height5),
            Text(
              'Activities',
              style: TextStyle(
                color: onSecondary,
                fontSize: Dimensions.height5 * 8,
              ),
            ),
            SizedBox(height: Dimensions.height5 * 2),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: onSecondary,
                  ),
                  hintText: "Search you're looking for",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: Dimensions.height5 * 3,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height5 * 2),
          ],
        ),
      ),
    );
  }
}
