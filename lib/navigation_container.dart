import 'package:flutter/material.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/pages/activity_page.dart';
import 'package:upoint/pages/add_post_page.dart';
import 'package:upoint/pages/home_page.dart';
import 'package:upoint/pages/manage_page.dart';
import 'package:upoint/pages/search_page.dart';
import 'package:upoint/widgets/custom_bottom_naviagation_bar.dart';
import 'package:upoint/pages/profile_page.dart';
import 'package:provider/provider.dart';

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

class _NavigationContainerState extends State<NavigationContainer>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;
  List<Widget> _pages = [];
  PageController _pageController = PageController();
  AddPostPageBloc bloc = AddPostPageBloc();
  final HomePageBloc _homePageBloc = HomePageBloc();

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

  late ValueNotifier valueNotifier;
  // Key _addPostPageKey = UniqueKey();
  void resetAddPostPage() {
    setState(() {
      bloc = AddPostPageBloc();
    });
  }

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier<AddPostPageBloc>(bloc);
    if (widget.uri != null) {
      if (widget.uri!.pathSegments.isNotEmpty &&
          widget.uri!.pathSegments.first == 'profile') {
        _selectedPageIndex = 0;
      } else if (widget.uri!.pathSegments.isNotEmpty &&
          widget.uri!.pathSegments.first == 'activity') {
        _selectedPageIndex = 0;
        findAndGoPost(widget.uri!.pathSegments[1]);
      }
    }
    _pageController = PageController(initialPage: _selectedPageIndex);
    WidgetsBinding.instance.addObserver(this);
  }

  findAndGoPost(postId) async {
    PostModel _p = await _homePageBloc.fetchPostById(postId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ActivityPage(
            post: _p,
            hero: "activity${_p.datePublished.toString()}",
            isOver: false,
            isOrganizer: widget.isOrganizer,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state : $state');
    if (state == AppLifecycleState.resumed) {
      // 应用从后台切换回前台
    }
    // 其他生命周期变化...
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userAccountManager = Provider.of<AuthMethods>(context, listen: false);
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: FutureBuilder(
          future: userAccountManager.getUserDetails(widget.isOrganizer),
          builder: (context, snapshot) {
            if (widget.isOrganizer) {
              _pages = [
                ManagePage(
                  searchTapped: searchTapped,
                  organizer: userAccountManager.organizer,
                ),
                AddPostPage(
                  backToHome: () {
                    onIconTapped(0);
                    resetAddPostPage();
                  },
                  isEdit: false,
                  // key: _addPostPageKey,
                  organizer: userAccountManager.organizer,
                  bloc: bloc,
                ),
                ProfilePage(
                  isOrganizer: widget.isOrganizer,
                  organizer: userAccountManager.organizer,
                ),
              ];
            } else {
              _pages = [
                HomePage(
                  bloc: _homePageBloc,
                  searchTapped: searchTapped,
                  user: userAccountManager.user,
                ),
                SearchPage(
                  bloc: _homePageBloc,
                  user: userAccountManager.user,
                ),
                Container(color: Colors.blue),
                Container(),
                ProfilePage(
                  isOrganizer: widget.isOrganizer,
                  user: userAccountManager.user,
                ),
              ];
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator.adaptive(
                backgroundColor: onSecondary,
              ));
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
          }),
    );
  }
}
