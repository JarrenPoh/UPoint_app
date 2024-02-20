import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';

import 'package:upoint/globals/dimension.dart';
import 'package:upoint/global_key.dart' as globals;

class CustomBottomNavigationBar extends StatefulWidget {
  CustomBottomNavigationBar({
    Key? key,
    required this.onIconTap,
    required this.selectedPageIndex,
  }) : super(key: globals.globalBottomNavigation ?? key);
  final int selectedPageIndex;
  final Function onIconTap;

  @override
  State<CustomBottomNavigationBar> createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int selectedPage;
  List labelText = [];
  List iconList = [];
  List<Widget> children = [];
  @override
  void initState() {
    super.initState();
    selectedPage = widget.selectedPageIndex;

    iconList = [
      Icons.home_filled,
      CupertinoIcons.search,
      Icons.add,
      Icons.inbox_rounded,
      CupertinoIcons.profile_circled,
    ];
    labelText = ["home", "search", "", "inbox", "profile"];
  }

  void onGlobalTap(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color_onPrimary = Theme.of(context).colorScheme.onPrimary;
    // final barHeight = MediaQuery.of(context).size.height * 0.06;
    final style = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: Dimensions.height2 * 5.5,
        );

    children = [
      _bottomBarNavItem(0, style, context),
      _bottomBarNavItem(1, style, context),
      // _addItem(2, barHeight, context),
      _bottomBarNavItem(3, style, context),
      _bottomBarNavItem(4, style, context),
    ];

    return BottomAppBar(
      height: 54,
      surfaceTintColor: color_onPrimary,
      color: color_onPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
    );
  }

  _bottomBarNavItem(
    int index,
    TextStyle textStyle,
    BuildContext context,
  ) {
    bool isSelected = selectedPage == index;
    Color iconAndTextColor = isSelected
        ? Theme.of(context).colorScheme.onSecondary
        : Theme.of(context).colorScheme.secondary;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onIconTap(index);
          onGlobalTap(index);
        },
        child: Container(
          color: CColor.of(context).white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 0),
                  Icon(
                    iconList[index],
                    color: iconAndTextColor,
                    size: 28,
                  ),
                  Text(
                    labelText[index],
                    style: textStyle.copyWith(
                      color: iconAndTextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
