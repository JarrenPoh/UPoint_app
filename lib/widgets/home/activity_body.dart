import 'package:flutter/material.dart';
import 'package:upoint/bloc/activity_body_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/scroll_things_provider.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/widgets/home/post_card.dart';
import 'package:upoint/widgets/home/promo_card.dart';

class ActivityBody extends StatefulWidget {
  final int index;
  final ActivityBodyBloc bloc;
  const ActivityBody({
    super.key,
    required this.index,
    required this.bloc,
  });

  @override
  State<ActivityBody> createState() => _ActivityBodyState();
}

class _ActivityBodyState extends State<ActivityBody>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color hintColor = Theme.of(context).hintColor;

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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width5 * 1.5,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: Dimensions.height5 * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Organizer',
                              style: TextStyle(
                                color: onSecondary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'see all ',
                              style: TextStyle(
                                color: hintColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height5 * 3),
                        Container(
                          height: Dimensions.height5 * 55,
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: Dimensions.height5 * 4,
                              mainAxisSpacing: Dimensions.width5 * 4,
                              childAspectRatio: 1.3,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children:
                                List.generate(widget.bloc.orgImgs.length, (index) {
                              return Column(
                                children: [
                                  PromoCard(
                                    imageUrl: widget.bloc.orgImgs[index],
                                    aspectRatio: 1 / 1,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MediumText(
                                        color: onSecondary,
                                        size: 12,
                                        text: '教務處',
                                      ),
                                      SizedBox(width: Dimensions.width2),
                                      MediumText(
                                        color: hintColor,
                                        size: 12,
                                        text: '3',
                                      )
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.height5 * 6),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width5 * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activity Today',
                          style: TextStyle(
                            color: onSecondary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Dimensions.height5 * 1),
                        Column(
                          children: List.generate(
                            widget.bloc.actImages.length,
                            (index) {
                              return PostCard(
                                post: PostModel(),
                                user: null,
                                hero: "activity${widget.bloc.actTitle[index]}",
                                isOrganizer: false,
                              );
                            },
                          ),
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
