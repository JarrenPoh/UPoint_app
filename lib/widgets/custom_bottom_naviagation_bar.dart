import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
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
  }

  void onGlobalTap(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color_onPrimary = Theme.of(context).colorScheme.onPrimary;

    children = [
      _bottomBarNavItem(0, context),
      _bottomBarNavItem(1, context),
      // _addItem(2, barHeight, context),
      _bottomBarNavItem(3, context),
      _bottomBarNavItem(4, context),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
