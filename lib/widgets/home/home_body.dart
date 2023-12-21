import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/widgets/home/main_area.dart';

class HomeBody extends StatefulWidget {
  final int index;
  const HomeBody({
    super.key,
    required this.index,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return RefreshIndicator(
                  displacement: Dimensions.height5 * 3,
            backgroundColor: onPrimary,
            color: onSecondary,
            onRefresh: () async {
              print('onRefresh');
            },
      child: CustomScrollView(
        controller:
            CustomScrollProviderData.of(context).scrollControllers[widget.index],
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // IntroArea(),
                Container(
                  color: scaffoldBackgroundColor,
                  child: MainArea(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
