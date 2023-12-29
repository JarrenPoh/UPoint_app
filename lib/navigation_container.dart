import 'package:flutter/material.dart';
import 'package:upoint/pages/add_post_page.dart';
import 'package:upoint/pages/home_page.dart';
import 'package:upoint/pages/search_page.dart';
import 'package:upoint/widgets/custom_bottom_naviagation_bar.dart';
import 'package:upoint/pages/profile_page.dart';

class NavigationContainer extends StatefulWidget {
  final Uri? uri;
  final bool isOrganizer;
  const NavigationContainer({
    super.key,
    required this.uri,
    required this.isOrganizer,
  });

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  List<Widget> _pages = [];
  PageController _pageController = PageController();
  int _selectedPageIndex = 0;
  void onIconTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void searchTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.uri != null) {
      if (widget.uri!.pathSegments.isNotEmpty &&
          widget.uri!.pathSegments.first == 'profile') {
        _selectedPageIndex = 4;
      }
    }
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOrganizer) {
      _pages = [
        Container(),
        AddPostPage(onIconTapped: onIconTapped),
        ProfilePage(),
      ];
    } else {
      _pages = [
        HomePage(searchTapped: searchTapped),
        SearchPage(),
        AddPostPage(onIconTapped: onIconTapped),
        Container(),
        ProfilePage(),
      ];
    }
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _pages[index];
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onIconTap: onIconTapped,
        selectedPageIndex: _selectedPageIndex,
        isOrganizer: widget.isOrganizer,
      ),
    );
  }
}
