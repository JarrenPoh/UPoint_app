// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:upoint/bloc/organizer_fetch_bloc.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/models/ad_model.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/pages/home_page.dart';
import 'package:upoint/pages/inbox_page.dart';
import 'package:upoint/pages/logo_page.dart';
import 'package:upoint/pages/rag_page.dart';
import 'package:upoint/pages/search_page.dart';
import 'package:upoint/widgets/custom_bottom_naviagation_bar.dart';
import 'package:upoint/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:upoint/widgets/custom_loading2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bloc/post_fetch_bloc.dart';
import 'globals/dimension.dart';
import 'models/user_model.dart';
import 'new_version-master/lib/new_version.dart';
import 'pages/login_page.dart';
import 'pages/post_detail_page.dart';

class NavigationContainer extends StatefulWidget {
  final Uri? uri;
  const NavigationContainer({
    super.key,
    required this.uri,
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
  late CColor cColor = CColor.of(context);
  UserModel? user;

  Future<void> _initPackageInfo() async {
    final newVersion = NewVersion(
      iOSId: 'com.upoint.ios',
      androidId: 'com.upoint.android',
      iOSAppStoreCountry: "tw",
    );
    final status = await newVersion.getVersionStatus();
    print("version is ${status?.storeVersion}");
    print("canUpdate is ${status?.canUpdate}");
    print("localVersion is ${status?.localVersion}");
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
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  openUrl() async {
    if (widget.uri != null) {
      if (widget.uri?.path == "/post") {
        final String? postId = widget.uri?.queryParameters['postId'];
        if (postId != null) {
          PostModel _p = await FirestoreMethods().fetchPostById(postId);
          Get.to(
            () => PostDetailPage(
              post: _p,
              hero: "post${DateTime.now()}",
            ),
          );
        }
      }
    }
  }

  late ValueNotifier valueNotifier;

  @override
  void initState() {
    super.initState();
    openUrl();
    _pageController = PageController(initialPage: _selectedPageIndex);
    WidgetsBinding.instance.addObserver(this);
    final ideaCardsBloc =
        Provider.of<OrganzierFetchBloc>(context, listen: false);
    ideaCardsBloc.fetchOrganizers();
  }

  // findAndGoPost(postId) async {
  //   // UserModel? user =
  //   //     await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
  //   PostModel _p = await FirestoreMethods().fetchPostById(postId);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return PostDetailPage(
  //           post: _p,
  //           hero: "activity${DateTime.now()}",
  //         );
  //       },
  //     ),
  //   );
  // }

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

  Future<List<AdModel>> getUserAndPost() async {
    try {
      print("Fetching user details...");
      final userAccountManager =
          Provider.of<AuthMethods>(context, listen: false);
      await userAccountManager.getUserDetails();
      print("User details fetched.");

      final postManager = Provider.of<PostFetchBloc>(context, listen: false);
      await postManager.fetch();
      print("Posts fetched.");

      print("Fetching ads...");
      List<AdModel> ad = await FirestoreMethods().fetchAllAd();
      print("Ads fetched successfully, returning ad list.");

      print("這粒啊啊啊");
      return ad;
    } catch (e) {
      print("Error in getUserAndPost: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _initPackageInfo();
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
                child: CustomLoadong2(),
              );
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
                List<AdModel> ad = snapshot.data ?? [];
                user = userNotifier.user;
                print('刷新用戶');
                return Consumer<PostFetchBloc>(
                    builder: (context, postNotifier, child) {
                  List<PostModel> post = postNotifier.post;
                  print('刷新貼文');
                  return PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: _pages(user, post, ad).length,
                    itemBuilder: (context, index) {
                      return _pages(user, post, ad)[index];
                    },
                  );
                });
              },
            );
          },
        ),
        floatingActionButton: CupertinoButton(
          onPressed: () async {
            if (user == null) {
              String res = await Messenger.dialog(
                '請先登入',
                '您尚未登入帳戶',
                context,
              );
              if (res == "success") {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              }
            } else {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return RagPage(
                    hero: "rag",
                    user: user!,
                  );
                },
              ));
            }
          },
          child: Hero(
            tag: "rag",
            transitionOnUserGestures: true,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cColor.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              width: Dimensions.height2 * 26,
              height: Dimensions.height2 * 26,
              child: SvgPicture.asset(
                color: Colors.white,
                width: Dimensions.height2 * 16,
                height: Dimensions.height2 * 16,
                "assets/robot.svg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          onIconTap: onIconTapped,
          selectedPageIndex: _selectedPageIndex,
        ),
      ),
    );
  }
}
