import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/widgets/home/activity_body.dart';
import 'package:upoint/widgets/home/shop_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  final HomePageBloc _homePageBloc = HomePageBloc();

  @override
  void initState() {
    super.initState();
    _homePageBloc.tabController = TabController(
      length: _homePageBloc.tabList.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color hintColor = Theme.of(context).hintColor;

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
                          child: TabBar(
                            overlayColor: null,
                            labelColor: onSecondary,
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            unselectedLabelColor: Colors.grey,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                              color: hintColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            indicatorPadding: EdgeInsets.only(
                              bottom: Dimensions.height2 * 4,
                              top: Dimensions.height2 * 18.5,
                              left: Dimensions.width5 * 2,
                              right: Dimensions.width5 * 2,
                            ),
                            indicatorWeight: 4,
                            onTap: (value) {
                              _homePageBloc.tabController.index = value;
                            },
                            controller: _homePageBloc.tabController,
                            tabs: List.generate(
                              _homePageBloc.tabList.length,
                              (index) => Tab(
                                  child: Text(_homePageBloc.tabList[index])),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SliverPersistentHeader(
                    //   pinned: true,
                    //   delegate: MySliverDelegate(
                    //     minHeight: Dimensions.height5 * 21,
                    //     maxHeight: Dimensions.height5 * 21,
                    //     child: Container(
                    //       color: appBarColor,
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: Dimensions.width5 * 6,
                    //         vertical: Dimensions.height5,
                    //       ),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'Find Your',
                    //             style: TextStyle(
                    //               color: onSecondary,
                    //               fontSize: Dimensions.height5 * 5,
                    //             ),
                    //           ),
                    //           SizedBox(height: Dimensions.height5),
                    //           Text(
                    //             'Activities',
                    //             style: TextStyle(
                    //               color: onSecondary,
                    //               fontSize: Dimensions.height5 * 8,
                    //             ),
                    //           ),
                    //           SizedBox(height: Dimensions.height5 * 2),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width5 * 4,
                                    vertical: Dimensions.height5 * 2,
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
                body: Builder(
                  builder: (context) {
                    return CustomScrollProvider(
                      tabController: _homePageBloc.tabController,
                      parent: PrimaryScrollController.of(context),
                      child: TabBarView(
                        controller: _homePageBloc.tabController,
                        children: [
                          ActivityBody(
                            index: 0,
                            bloc: _homePageBloc.activityBodyBloc,
                          ),
                          ShopBody(
                            index: 1,
                            bloc: _homePageBloc.shopBodyBloc,
                          ),
                        ],
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
