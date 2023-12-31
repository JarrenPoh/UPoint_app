import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/manage_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/global_key.dart' as globals;
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/widgets/home/post_card.dart';

import '../models/user_model.dart';

class ManagePage extends StatefulWidget {
  final Function(int) searchTapped;
  final User? user;
  ManagePage({
    Key? key,
    required this.searchTapped,
    required this.user,
  }) : super(key: globals.globalManagePage ?? key);

  @override
  State<ManagePage> createState() => ManagePageState();
}

class ManagePageState extends State<ManagePage>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  late ManageBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = ManageBloc(widget.user!.uuid);
  }

  Future<void> updatePost(postId)async{
    await _bloc.updatePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
          color: appBarColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: scaffoldBackgroundColor,
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: MySliverDelegate(
                        minHeight: Dimensions.height5 * 10,
                        maxHeight: Dimensions.height5 * 10,
                        child: Container(
                          color: appBarColor,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                child: CupertinoButton(
                                  onPressed: () {
                                    widget.searchTapped(1);
                                    globals
                                        .globalBottomNavigation!.currentState!
                                        .onGlobalTap(1);
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: onSecondary,
                                    size: Dimensions.height5 * 6,
                                  ),
                                ),
                              ),
                              Center(
                                child: MediumText(
                                  color: onSecondary,
                                  size: 18,
                                  text: "管理系統",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                          backgroundColor: appBarColor,
                          expandedHeight: Dimensions.height5 * 6,
                          forceElevated: innerBoxIsScrolled,
                          pinned: false,
                          floating: true,
                          elevation: 0,
                          bottom: PreferredSize(
                            preferredSize: Size(
                              Dimensions.screenWidth,
                              Dimensions.height5 * 6,
                            ),
                            child: Container(
                              color: scaffoldBackgroundColor,
                              child: Container(
                                width: Dimensions.screenWidth,
                                decoration: BoxDecoration(
                                  color: appBarColor,
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: Dimensions.width5 * 4,
                                    right: Dimensions.width5 * 4,
                                    bottom: Dimensions.height5 * 3,
                                  ),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: onSecondary,
                                      ),
                                      hintText: "Search you're looking for",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: Dimensions.height5 * 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ];
                },
                body: ValueListenableBuilder(
                  valueListenable: _bloc.postListNotifier,
                  builder: (context, value, child) {
                    value as List;
                    List<PostModel> postList = [];
                    value.forEach((e) {
                      postList.add(
                        PostModel.fromSnap(e),
                      );
                    });
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width5 * 2,
                      ),
                      child: postList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MediumText(
                                    color: onSecondary,
                                    size: 16,
                                    text: "還沒有創建過貼文",
                                  ),
                                  CupertinoButton(
                                    onPressed: () {
                                      widget.searchTapped(1);
                                      globals
                                          .globalBottomNavigation!.currentState!
                                          .onGlobalTap(1);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: onSecondary,
                                      size: Dimensions.height5 * 6,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              displacement: Dimensions.height5 * 3,
                              backgroundColor: onPrimary,
                              color: onSecondary,
                              onRefresh: () async {
                                await _bloc.fetchPosts(widget.user!.uuid);
                              },
                              child: ListView(
                                children: List.generate(
                                  postList.length,
                                  (index) {
                                    return PostCard(
                                      post: postList[index],
                                      user: widget.user!,
                                      hero:
                                          "activity${postList[index].datePublished}",
                                      isOrganizer: true,
                                    );
                                  },
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MySliverDelegate extends SliverPersistentHeaderDelegate {
  MySliverDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight; //最小高度
  final double maxHeight; //最大高度
  final Widget child; //子Widget布局

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => (maxHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
