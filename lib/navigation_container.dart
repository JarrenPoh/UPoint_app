import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/bloc/manage_bloc.dart';
import 'package:upoint/bloc/uri_bloc.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/pages/activity_page.dart';
import 'package:upoint/pages/add_post_page.dart';
import 'package:upoint/pages/home_page.dart';
import 'package:upoint/pages/manage_page.dart';
import 'package:upoint/pages/search_page.dart';
import 'package:upoint/secret.dart';
import 'package:upoint/widgets/custom_bottom_naviagation_bar.dart';
import 'package:upoint/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:upoint/widgets/custom_dialog.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({
    super.key,
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
  late bool isOrganizer = false;
  ManageBloc? _managePageBloc;

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
    print('here1');
    if (FirebaseAuth.instance.currentUser != null) {
      String email = FirebaseAuth.instance.currentUser!.email!;
      if(organList.contains(email)){
        isOrganizer = true;
      }
    }
    valueNotifier = ValueNotifier<AddPostPageBloc>(bloc);
    Uri? uri = Provider.of<UriBloc>(context, listen: false).uri;
    if (uri != null) {
      print('uri: $uri');
      if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'profile') {
        _selectedPageIndex = 0;
      } else if (uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first == 'activity') {
        _selectedPageIndex = 0;
        findAndGoPost(uri.pathSegments[1]);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<UriBloc>(context, listen: false).setUri(null);
      });
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
            isOrganizer: isOrganizer,
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
    print('here');
    return WillPopScope(
      onWillPop: () async {
        return await CustomDialog(
          context,
          '您要離開了嗎',
          '要確定ㄟ',
          onSecondary,
          onSecondary,
          () async {
            Navigator.of(context).pop(true);
          },
        );
      },
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: FutureBuilder(
          future: userAccountManager.getUserDetails(isOrganizer),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator.adaptive(
                backgroundColor: onSecondary,
              ));
            }
            if (isOrganizer) {
              _managePageBloc = ManageBloc(userAccountManager.organizer!.uid);
              _pages = [
                ManagePage(
                  searchTapped: searchTapped,
                  organizer: userAccountManager.organizer,
                  bloc: _managePageBloc!,
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
                  isOrganizer: isOrganizer,
                  organizer: userAccountManager.organizer,
                  valueListenable: _managePageBloc!.postListNotifier,
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
                  isOrganizer: isOrganizer,
                  user: userAccountManager.user,
                ),
              ];
            }
            return PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _pages[index];
              },
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          onIconTap: onIconTapped,
          selectedPageIndex: _selectedPageIndex,
          isOrganizer: isOrganizer,
        ),
      ),
    );
  }
}
