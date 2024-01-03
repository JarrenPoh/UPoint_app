import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/overscroll_pop-main/lib/overscroll_pop.dart';
import 'package:upoint/pages/login_page.dart';
import 'package:upoint/pages/sign_list_page.dart';
import 'package:upoint/pages/signup_form_page.dart';
import 'package:upoint/widgets/custom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:provider/provider.dart';

class ActivityPage extends StatefulWidget {
  final PostModel post;
  final String hero;
  final bool isOver;
  final bool isOrganizer;
  const ActivityPage({
    super.key,
    required this.post,
    required this.hero,
    required this.isOver,
    required this.isOrganizer,
  });

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    // Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color primary = Theme.of(context).colorScheme.primary;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color hintColor = Theme.of(context).hintColor;

    return OverscrollPop(
      scrollToPopOption: ScrollToPopOption.start,
      dragToPopDirection: DragToPopDirection.horizontal,
      child: Scaffold(
        backgroundColor: appBarColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: Dimensions.screenHeight * 0.24,
              elevation: 0,
              snap: true,
              floating: true,
              stretch: true,
              backgroundColor: appBarColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  width: Dimensions.height2 * 23,
                  height: Dimensions.height2 * 23,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      40,
                    ),
                    color: appBarColor,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.chevron_left_outlined,
                      color: hintColor,
                      size: Dimensions.height2 * 18,
                    ),
                  ),
                ),
              ),
              actions: [
                CupertinoButton(
                  onPressed: () async {
                    String postLink = 'sadasfdafafsf';
                    try {
                      await Share.share(
                        'text' + postLink,
                        subject: 'subject',
                      );
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Container(
                    width: Dimensions.height2 * 20,
                    height: Dimensions.height2 * 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        40,
                      ),
                      color: appBarColor,
                    ),
                    child: Icon(
                      Icons.share,
                      color: hintColor,
                      size: Dimensions.height2 * 12,
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.blurBackground,
                  StretchMode.zoomBackground
                ],
                background: Hero(
                  transitionOnUserGestures: true,
                  tag: widget.hero,
                  child: CachedNetworkImage(
                    imageUrl: widget.post.photos!.first,
                    imageBuilder: ((context, imageProvider) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 10,
                            child: Container(
                              height: Dimensions.height5 * 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imageProvider,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.isOver
                                      ? Colors.black.withOpacity(0.8)
                                      : null,
                                  borderRadius: BorderRadius.circular(0),
                                  gradient: widget.isOver
                                      ? null
                                      : LinearGradient(
                                          begin: Alignment.bottomRight,
                                          stops: const [0.3, 0.9],
                                          colors: [
                                            Colors.black.withOpacity(.8),
                                            Colors.black.withOpacity(.2),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                          widget.post.reward != null
                              ? Positioned(
                                  left: 0,
                                  top: Dimensions.height2 * 10,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width5 * 4,
                                      vertical: Dimensions.height5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: hintColor.withOpacity(.65),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: MediumText(
                                      color: Colors.white,
                                      size: 16,
                                      text: widget.post.reward!,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      );
                    }),
                    placeholder: (context, url) => SizedBox(
                      height: Dimensions.height5 * 3,
                      width: Dimensions.height5 * 3,
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(Dimensions.height5 * 6),
                child: Container(
                  height: Dimensions.height5 * 6,
                  decoration: BoxDecoration(
                    color: appBarColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: Dimensions.width5 * 10,
                      height: Dimensions.height2 * 4,
                      decoration: BoxDecoration(
                        color: primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width5 * 4,
                          vertical: Dimensions.height5 * 6,
                        ),
                        color: appBarColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: Dimensions.screenWidth * 0.55,
                                        child: Text(
                                          widget.post.title!,
                                          style: TextStyle(
                                            color: onSecondary,
                                            fontSize: Dimensions.height2 * 11,
                                            fontFamily: "NotoSansMedium",
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Dimensions.height5 * 2),
                                      Container(
                                        width: Dimensions.screenWidth * 0.55,
                                        child: Text(
                                          widget.post.organizer!,
                                          style: TextStyle(
                                            color: hintColor,
                                            fontSize: Dimensions.height2 * 8,
                                            fontFamily: "NotoSansMedium",
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Dimensions.height5 * 4),
                                    ],
                                  ),
                                ),
                                Expanded(child: Column(children: [])),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: Dimensions.screenWidth * 0.3,
                                      child: Text(
                                        formatTimestamp(widget.post.date),
                                        style: TextStyle(
                                          color: onSecondary,
                                          fontSize: Dimensions.height2 * 8,
                                          fontFamily: "NotoSansMedium",
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height5 * 2),
                                    Text(
                                      '${widget.post.startTime}-${widget.post.endTime}',
                                      style: TextStyle(
                                        color: onSecondary,
                                        fontSize: Dimensions.height2 * 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              widget.post.content!,
                              style: TextStyle(
                                height: 1.5,
                                color: primary,
                                fontSize: Dimensions.height2 * 8,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5 * 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: appBarColor,
              // boxShadow: [
              //   BoxShadow(
              //     color: primary,
              //     blurRadius: 5.0,
              //     offset: Offset(0, -5),
              //   ),
              // ],
            ),
            padding: EdgeInsets.only(
              bottom: 0,
              left: Dimensions.width5 * 2,
              right: Dimensions.width5 * 2,
            ),
            height: Dimensions.height5 * 12.5,
            child: Row(
              children: [
                widget.post.link != null && widget.post.link!.isNotEmpty
                    ? SizedBox(
                        width: Dimensions.width5 * 50,
                        child: CupertinoButton(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height5 * 3,
                          ),
                          onPressed: widget.post.link == null
                              ? () {}
                              : () async {
                                  final String url = widget.post.link!;
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                },
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          child: Center(
                            child: MediumText(
                              color: Colors.white,
                              size: 18,
                              text: "查看更多報名資訊",
                            ),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  width:
                      widget.post.link != null && widget.post.link!.isNotEmpty
                          ? Dimensions.width5 * 2
                          : 0,
                ),
                Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height5 * 3,
                    ),
                    onPressed: widget.isOrganizer
                        ? () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) {
                                  return SignListPage(
                                    post: widget.post,
                                  );
                                }),
                              ),
                            );
                          }
                        : widget.isOver
                            ? () {}
                            : () async {
                                if (auth.FirebaseAuth.instance.currentUser ==
                                    null) {
                                  await CustomDialog(
                                    context,
                                    '請先登入',
                                    '您尚未登入帳戶',
                                    onSecondary,
                                    onSecondary,
                                    () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                            uri: Uri(pathSegments: [
                                              'activity',
                                              widget.post.postId!,
                                            ]),
                                          ),
                                        ),
                                        (Route<dynamic> route) =>
                                            false, // 不保留任何旧路由
                                      );
                                    },
                                  );
                                }
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return FutureBuilder(
                                          future: Provider.of<AuthMethods>(
                                                  context,
                                                  listen: false)
                                              .getUserDetails(false),
                                          builder: (context, snapshot) {
                                            User _user =
                                                Provider.of<AuthMethods>(
                                                        context,
                                                        listen: false)
                                                    .user!;
                                            return SignUpFormPage(
                                              post: widget.post,
                                              user: _user,
                                            );
                                          });
                                    },
                                  ),
                                );
                              },
                    borderRadius: BorderRadius.circular(10),
                    color: widget.isOrganizer
                        ? hintColor
                        : widget.isOver
                            ? Colors.grey
                            : hintColor,
                    child: Center(
                      child: MediumText(
                        color: Colors.white,
                        size: 18,
                        text: widget.isOrganizer
                            ? "查看報名名單"
                            : widget.isOver
                                ? "已結束"
                                : "報名",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
