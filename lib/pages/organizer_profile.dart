import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/organizer_model.dart';
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
  final List tabList = ["基本資料", "所有活動", "貼文公告"];
  late final TabController _tabController =
      TabController(length: tabList.length, vsync: this, initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cColor.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                iconTheme: const IconThemeData(color: Colors.white, size: 20),
                backgroundColor: cColor.primary,
                title: MediumText(
                  color: Colors.white,
                  size: Dimensions.height2 * 8,
                  text: widget.organizer.username,
                ),
                forceElevated: innerBoxIsScrolled,
                // expandedHeight: 160,
                pinned: false,
                floating: true,
                // bottom: PreferredSize(
                //   preferredSize:
                //       Size(Dimensions.screenWidth, Dimensions.height5 * 16),
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(
                //       vertical: Dimensions.height2 * 8,
                //       horizontal: Dimensions.width2 * 8,
                //     ),
                //     child: Column(
                //       children: [
                //         // 概覽
                //         preview(),
                //         SizedBox(height: Dimensions.height2 * 4),
                //       ],
                //     ),
                //   ),
                // ),
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
                    // 概覽
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
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.height2 * 4),
                    Container(
                      height: Dimensions.height2 * 22,
                      color: cColor.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width2 * 14,
                        vertical: Dimensions.height2 * 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          tabList.length,
                          (index) => switchTab(text: tabList[index]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(width: 20, height: 600, color: Colors.amber),
              Container(width: 20, height: 600, color: Colors.black),
              Container(width: 20, height: 600, color: Colors.red),
              Container(width: 20, height: 600, color: Colors.amber),
            ],
          ),
        ),
      ),
    );
  }

  Widget switchTab({required String text}) {
    return Container(
      width: Dimensions.width5 * 18,
      height: Dimensions.height2 * 14,
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height2 * 2,
        horizontal: Dimensions.width2 * 6,
      ),
      alignment: Alignment.center,
      child: MediumText(color: cColor.primary, size: 14, text: text),
    );
  }

  Widget preview() {
    return Container(
      height: Dimensions.height5 * 16,
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height2 * 4,
        horizontal: Dimensions.width2 * 6,
      ),
      child: Row(
        children: [
          Column(
            children: [
              Expanded(
                child: AspectRatio(
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
              ),
            ],
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
          SizedBox(
            height: Dimensions.height2 * 12.5,
            child: CupertinoButton(
              onPressed: () {},
              padding: const EdgeInsets.all(0),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width2 * 4,
                  vertical: Dimensions.height2 * 2,
                ),
                decoration: BoxDecoration(
                  color: cColor.primary,
                  // border: Border.all(color: cColor.primary),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const MediumText(
                  // color: cColor.primary,
                  color: Colors.white,
                  size: 12,
                  text: "追蹤",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
