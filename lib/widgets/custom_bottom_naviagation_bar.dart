import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:upoint/globals/dimension.dart';
import 'package:upoint/global_key.dart' as globals;

class CustomBottomNavigationBar extends StatefulWidget {
  CustomBottomNavigationBar({
    Key? key,
    required this.onIconTap,
    required this.selectedPageIndex,
    required this.isOrganizer,
  }) : super(key: globals.globalBottomNavigation ?? key);
  final int selectedPageIndex;
  final Function onIconTap;
  final bool isOrganizer;

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
    if (widget.isOrganizer) {
      iconList = [
        Icons.home_filled,
        Icons.add,
        CupertinoIcons.profile_circled,
      ];
      labelText = ["home", "create", "profile"];
    } else {
      iconList = [
        Icons.home_filled,
        CupertinoIcons.search,
        Icons.add,
        Icons.inbox_rounded,
        CupertinoIcons.profile_circled,
      ];
      labelText = ["home", "search", "", "inbox", "profile"];
    }
  }

  void onGlobalTap(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color_onPrimary = Theme.of(context).colorScheme.onPrimary;
    final barHeight = MediaQuery.of(context).size.height * 0.06;
    final style = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: Dimensions.height2 * 5.5,
        );
    if (widget.isOrganizer) {
      children = [
        _bottomBarNavItem(0, style, context),
        _bottomBarNavItem(1, style, context),
        _bottomBarNavItem(2, style, context),
      ];
    } else {
      children = [
        _bottomBarNavItem(0, style, context),
        _bottomBarNavItem(1, style, context),
        _addItem(2, barHeight, context),
        _bottomBarNavItem(3, style, context),
        _bottomBarNavItem(4, style, context),
      ];
    }
    return BottomAppBar(
      color: color_onPrimary,
      child: Container(
        height: barHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: children,
        ),
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

    return GestureDetector(
      onTap: () {
        widget.onIconTap(index);
        onGlobalTap(index);
      },
      child: SizedBox(
        width: Dimensions.width5 * 14,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.height2 * 1.5),
            Icon(
              iconList[index],
              color: iconAndTextColor,
              size: Dimensions.height5 * 5,
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
      ),
    );
  }

  _addItem(index, height, BuildContext context) {
    return GestureDetector(
      onTap: () => {
        widget.onIconTap(index),
        onGlobalTap(index),
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: height - Dimensions.height5 * 3,
            width: Dimensions.width5 * 8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/launch_1024.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(Dimensions.height2 * 4),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
