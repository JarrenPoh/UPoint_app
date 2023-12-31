import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/overscroll_pop-main/lib/overscroll_pop.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:upoint/globals/date_time_transfer.dart';

class ActivityPage extends StatefulWidget {
  final PostModel post;
  final String hero;
  const ActivityPage({
    super.key,
    required this.post,
    required this.hero,
  });

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color primary = Theme.of(context).colorScheme.primary;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color hintColor = Theme.of(context).hintColor;

    return OverscrollPop(
      scrollToPopOption: ScrollToPopOption.start,
      dragToPopDirection: DragToPopDirection.horizontal,
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: Dimensions.screenHeight * 0.25,
              elevation: 0,
              snap: true,
              floating: true,
              stretch: true,
              backgroundColor: primaryContainer,
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
                    color: primaryContainer,
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
                      color: primaryContainer,
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
                  child: Image.network(
                    widget.post.photos!.first,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(Dimensions.height5 * 6),
                child: Container(
                  height: Dimensions.height5 * 6,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
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
                        color: scaffoldBackgroundColor,
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
                              'Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate! ',
                              style: TextStyle(
                                height: 1.5,
                                color: primary,
                                fontSize: Dimensions.height2 * 8,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5 * 6),
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () async {
                                      const url =
                                          'https://youtu.be/7x_XGlto9Bk?si=PfHB4WJggF8LdTO4';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      }
                                    },
                                    height: Dimensions.height5 * 10,
                                    elevation: 0,
                                    splashColor: hintColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: hintColor,
                                    child: Center(
                                      child: Text(
                                        "前往報名連結",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimensions.height2 * 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimensions.width5 * 2),
                                SizedBox(
                                  width: Dimensions.width5 * 12,
                                  child: MaterialButton(
                                    onPressed: () async {
                                      String postLink = 'sadasfdafafsf';
                                      print('press');
                                      try {
                                        await Share.share(
                                          'text' + postLink,
                                          subject: 'subject',
                                        );
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                    },
                                    height: Dimensions.height5 * 10,
                                    elevation: 0,
                                    splashColor: hintColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: hintColor,
                                    child: Center(
                                      child: Icon(
                                        Icons.share,
                                        color: Colors.white,
                                        size: Dimensions.height5 * 4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
