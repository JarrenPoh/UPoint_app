import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/organizer_model.dart';
import 'package:upoint/overscroll_pop-main/lib/overscroll_pop.dart';
import 'package:upoint/widgets/organizer_profile/organizer_profile_announce.dart';
import 'package:upoint/widgets/organizer_profile/organizer_profile_inform.dart';
import 'package:upoint/widgets/organizer_profile/organizer_profile_post.dart';
import '../firebase/auth_methods.dart';
import '../globals/custom_messengers.dart';
import '../globals/scroll_things_provider.dart';
import '../models/user_model.dart';
import 'login_page.dart';
import 'profile_page.dart';

class OrganizerProfile extends StatefulWidget {
  final OrganizerModel organizer;
  final String hero;
  const OrganizerProfile({
    super.key,
    required this.organizer,
    required this.hero,
  });

  @override
  State<OrganizerProfile> createState() => _OrganizerProfileState();
}

class _OrganizerProfileState extends State<OrganizerProfile>
    with TickerProviderStateMixin {
  late CColor cColor = CColor.of(context);
  final List<String> tabList = ["基本資料", "所有活動", "貼文公告"];
  late final TabController _tabController =
      TabController(length: tabList.length, vsync: this, initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return OverscrollPop(
      scrollToPopOption: ScrollToPopOption.start,
      dragToPopDirection: DragToPopDirection.horizontal,
      child: Scaffold(
        backgroundColor: cColor.white,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  iconTheme: const IconThemeData(color: Colors.white, size: 20),
                  backgroundColor: cColor.primary,
                  title: MediumText(
                    color: Colors.white,
                    size: Dimensions.height2 * 8,
                    text: widget.organizer.username,
                  ),
                  forceElevated: innerBoxIsScrolled,
                  pinned: true,
                  floating: true,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height2 * 8,
                    horizontal: Dimensions.width2 * 8,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 100),
                      preview(),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: MySliverDelegate(
                  maxHeight: Dimensions.height2 * 26,
                  minHeight: Dimensions.height2 * 26,
                  child: Container(
                    color: cColor.white,
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: cColor.primary,
                          unselectedLabelColor: cColor.grey500,
                          indicatorColor: Colors.transparent,
                          dividerColor: Colors.transparent,
                          labelStyle:
                              const TextStyle(fontFamily: "NotoSansMedium"),
                          tabs: List.generate(
                            tabList.length,
                            (index) => Tab(text: tabList[index]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width2 * 13),
                          child: Divider(
                            color: cColor.grey200, // 設置灰色線條顏色
                            thickness: 1, // 設置線條厚度
                            height: 1, // 設置線條高度
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Builder(builder: (context) {
            return CustomScrollProvider(
              tabController: _tabController,
              parent: PrimaryScrollController.of(context),
              child: TabBarView(
                controller: _tabController,
                children: [
                  OrganizerProfileInform(
                    organizer: widget.organizer,
                    index: 0,
                  ),
                  OrganizerProfilePost(
                    organizer: widget.organizer,
                    index: 1,
                  ),
                  OrganizerProfileAnnounce(
                    organizer: widget.organizer,
                    index: 2,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  follow({required UserModel? user}) async {
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
      await FirestoreMethods().followOrganizer(
        user: user,
        organizerUid: widget.organizer.uid,
      );
      UserModel _update = UserModel.fromMap(user.toJson())!;
      if (_update.followings?.contains(widget.organizer.uid) ?? false) {
        _update.followings?.removeWhere((e) => e == widget.organizer.uid);
      } else {
        _update.followings?.add(widget.organizer.uid);
      }
      await Provider.of<AuthMethods>(context, listen: false)
          .updateUserDetails(_update);
    }
  }

  Widget preview() {
    return Consumer<AuthMethods>(builder: (context, userNotifier, child) {
      UserModel? user = userNotifier.user;
      bool isFollow = user?.followings?.contains(widget.organizer.uid) ?? false;
      return Container(
        height: Dimensions.height5 * 16,
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height2 * 4,
          horizontal: Dimensions.width2 * 6,
        ),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Hero(
                transitionOnUserGestures: true,
                tag: widget.hero,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.organizer.pic),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.width2 * 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MediumText(
                    color: cColor.grey500,
                    size: 16,
                    text: widget.organizer.username,
                  ),
                  MediumText(
                    color: cColor.grey500,
                    size: 12,
                    text: "${widget.organizer.postLength}場活動",
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width2 * 8),
            if (!(user?.uuid == widget.organizer.uid))
              SizedBox(
                height: Dimensions.height2 * 13,
                child: CupertinoButton(
                  onPressed: () => follow(user: user),
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width2 * 8,
                      vertical: Dimensions.height2 * 2,
                    ),
                    decoration: BoxDecoration(
                      color: isFollow ? cColor.white : cColor.primary,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: cColor.primary),
                    ),
                    child: MediumText(
                      color: Colors.white,
                      size: 12,
                      text: isFollow ? "取消追蹤" : "追蹤",
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
