import 'package:flutter/material.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/widgets/home/post_card.dart';

class RewardBody extends StatefulWidget {
  final int index;
  final HomePageBloc bloc;
  const RewardBody({
    super.key,
    required this.index,
    required this.bloc,
  });

  @override
  State<RewardBody> createState() => _RewardBodyState();
}

class _RewardBodyState extends State<RewardBody>
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
        controller: CustomScrollProviderData.of(context)
            .scrollControllers[widget.index],
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: scaffoldBackgroundColor,
              child: Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: Dimensions.width5 * 1.5,
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       SizedBox(height: Dimensions.height5 * 2),
                  //       Row(
                  //         children: [
                  //           Text(
                  //             'Promo Today',
                  //             style: TextStyle(
                  //               color: onSecondary,
                  //               fontSize: 24,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(height: Dimensions.height5 * 3),
                  //       Container(
                  //         height: Dimensions.height5 * 45,
                  //         child: GridView(
                  //           gridDelegate:
                  //               SliverGridDelegateWithFixedCrossAxisCount(
                  //             crossAxisCount: 1,
                  //             crossAxisSpacing: Dimensions.height5 * 4,
                  //             mainAxisSpacing: Dimensions.width5 * 4,
                  //             childAspectRatio: 1.6,
                  //           ),
                  //           shrinkWrap: true,
                  //           scrollDirection: Axis.horizontal,
                  //           children: List.generate(
                  //               widget.bloc.promoImages.length, (index) {
                  //             return PromoCard(
                  //               imageUrl: widget.bloc.promoImages[index],
                  //               aspectRatio: 2 / 3,
                  //             );
                  //           }),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: Dimensions.height5 * 6),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width5 * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Restaurant',
                          style: TextStyle(
                            color: onSecondary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Dimensions.height5 * 1),
                        ValueListenableBuilder(
                          valueListenable: widget.bloc.postListNotifier,
                          builder: (BuildContext context, dynamic value,
                              Widget? child) {
                            value as List;
                            List<PostModel> postList = [];
                            value.forEach((e) {
                              postList.add(
                                PostModel.fromSnap(e),
                              );
                            });
                            return postList.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MediumText(
                                          color: onSecondary,
                                          size: 16,
                                          text: "還沒有創建過貼文",
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: List.generate(
                                      postList.length,
                                      (index) {
                                        return PostCard(
                                          post: postList[index],
                                          organizer: null,
                                          hero:
                                              "reward${postList[index].datePublished.toString()}",
                                          isOrganizer: false,
                                        );
                                      },
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
