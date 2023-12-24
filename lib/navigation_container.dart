import 'package:flutter/material.dart';
import 'package:upoint/pages/add_post_page.dart';
import 'package:upoint/pages/home_page.dart';
import 'package:upoint/pages/search_page.dart';
import 'package:upoint/widgets/custom_bottom_naviagation_bar.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({super.key});

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  List<Widget> _pages = [];
  final PageController _pageController = PageController();
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
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      HomePage(searchTapped: searchTapped),
      SearchPage(),
      AddPostPage(onIconTapped: onIconTapped),
      Container(),
      Container(),
    ];
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
      ),
    );
  }
}
