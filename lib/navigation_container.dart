// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:upoint/bloc/uri_bloc.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/models/ad_model.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/pages/post_detail_page.dart';
import 'package:upoint/pages/home_page.dart';
import 'package:upoint/pages/inbox_page.dart';
import 'package:upoint/pages/logo_page.dart';
import 'package:upoint/pages/search_page.dart';
import 'package:upoint/widgets/custom_bottom_naviagation_bar.dart';
import 'package:upoint/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/user_model.dart';
import 'new_version-master/lib/new_version.dart';

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
  List<Widget> Function(UserModel?, List<PostModel>, List<AdModel>) _pages =
      (u, p, a) => [];
  PageController _pageController = PageController();

  Future<void> _initPackageInfo() async {
    final newVersion = NewVersion(
      iOSId: 'com.upoint.ios',
      androidId: 'com.upoint.android.',
      iOSAppStoreCountry: "tw",
    );
    final status = await newVersion.getVersionStatus();
    if (status != null && status.canUpdate) {
      await Messenger.updateDialog(
        "version ${status.storeVersion} is now available",
        "請先點擊前往更新最新的版本",
        context,
      );
      launchUrl(Uri.parse(status.appStoreLink));
    }
  }

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

  @override
  void initState() {
    super.initState();
    Uri? uri = Provider.of<UriBloc>(context, listen: false).uri;
    if (uri != null) {
      debugPrint('uri: $uri');
      if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'profile') {
        _selectedPageIndex = 0;
      } else if (uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first == 'activity') {
        _selectedPageIndex = 0;
        findAndGoPost(uri.queryParameters['id']);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<UriBloc>(context, listen: false).setUri(null);
      });
    }
    _pageController = PageController(initialPage: _selectedPageIndex);
    WidgetsBinding.instance.addObserver(this);
  }

  findAndGoPost(postId) async {
    // UserModel? user =
    //     await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
    PostModel _p = await FirestoreMethods().fetchPostById(postId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(
            post: _p,
            hero: "activity${DateTime.now()}",
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
    debugPrint('state : $state');
    if (state == AppLifecycleState.resumed) {
      // 应用从后台切换回前台
    }
    // 其他生命周期变化...
  }

  Future<Map> getUserAndPost() async {
    final userAccountManager = Provider.of<AuthMethods>(context, listen: false);
    await userAccountManager.getUserDetails();
    List<PostModel> post = await FirestoreMethods().fetchAllPost();
    List<AdModel> ad = await FirestoreMethods().fetchAllAd();
    return {
      "post": post,
      "ad": ad,
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _initPackageInfo();
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return WillPopScope(
      onWillPop: () async {
        String res = await Messenger.dialog("您要離開了嗎", "要確定ㄟ", context);
        if (res == "success") {
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: FutureBuilder(
          future: getUserAndPost(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator.adaptive(
                backgroundColor: onSecondary,
              ));
            }
            _pages =
                (UserModel? _user, List<PostModel> _post, List<AdModel> ad) => [
                      HomePage(
                        allPost: _post,
                        searchTapped: searchTapped,
                        user: _user,
                        allAd: ad,
                      ),
                      SearchPage(
                        allPost: _post,
                        user: _user,
                      ),
                      LogoPage(),
                      InboxPage(
                        user: _user,
                      ),
                      ProfilePage(
                        user: _user,
                      ),
                    ];
            // }
            return Consumer<AuthMethods>(
              builder: (context, userNotifier, child) {
                List<PostModel> post = snapshot.data?["post"] ?? [];
                List<AdModel> ad = snapshot.data?["ad"] ?? [];
                UserModel? user = userNotifier.user;
                print('這裡有改');
                return PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: _pages(user, post, ad).length,
                  itemBuilder: (context, index) {
                    return _pages(user, post, ad)[index];
                  },
                );
              },
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          onIconTap: onIconTapped,
          selectedPageIndex: _selectedPageIndex,
        ),
      ),
    );
  }
}
