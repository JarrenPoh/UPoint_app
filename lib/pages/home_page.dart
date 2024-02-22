import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/activity_body.dart';
import 'package:upoint/widgets/home/reward_body.dart';

class HomePage extends StatefulWidget {
  final Function(int) searchTapped;
  final HomePageBloc bloc;
  final UserModel? user;
  const HomePage({
    super.key,
    required this.searchTapped,
    required this.bloc,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;

  @override
  void initState() {
    super.initState();
    widget.bloc.tabController = TabController(
      length: widget.bloc.tabList.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CColor cColor = CColor.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          color: cColor.white,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: cColor.div,
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        pinned: true,
                        elevation: 0,
                        backgroundColor: cColor.white,
                        title: PreferredSize(
                          preferredSize: Size(
                              Dimensions.screenWidth, Dimensions.height5 * 0),
                          child: TabBar(
                            dividerColor: Colors.transparent,
                            labelColor: cColor.grey500,
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            unselectedLabelColor: cColor.grey300,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                              color: cColor.primary,
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
                              widget.bloc.tabController.index = value;
                            },
                            controller: widget.bloc.tabController,
                            tabs: List.generate(
                              widget.bloc.tabList.length,
                              (index) => Tab(
                                child: Text(widget.bloc.tabList[index]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Builder(
                  builder: (context) {
                    return CustomScrollProvider(
                      tabController: widget.bloc.tabController,
                      parent: PrimaryScrollController.of(context),
                      child: TabBarView(
                        controller: widget.bloc.tabController,
                        children: [
                          ActivityBody(
                            index: 0,
                            bloc: widget.bloc,
                            user: widget.user,
                          ),
                          RewardBody(
                            index: 1,
                            bloc: widget.bloc,
                            user: widget.user,
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
