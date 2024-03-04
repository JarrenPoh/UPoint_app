import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/models/reward_tag_model.dart';
import '../../bloc/tab_reward_bloc.dart';
import '../../globals/medium_text.dart';

class TabRewardBodyFilter extends StatefulWidget {
  final TabRewardBloc bloc;
  const TabRewardBodyFilter({
    super.key,
    required this.bloc,
  });

  @override
  State<TabRewardBodyFilter> createState() => _TabRewardBodyFilterState();
}

class _TabRewardBodyFilterState extends State<TabRewardBodyFilter> {
  String searchText = "全部";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    return Container(
      height: Dimensions.height5 * 19,
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.height2 * 6,
      ),
      decoration: BoxDecoration(
        color: cColor.white,
      ),
      child: ValueListenableBuilder(
        valueListenable: widget.bloc.rewardTagListNotifier,
        builder: (context, value, child) {
          List<RewardTagModel> _rewardList = value;
          if (_rewardList.isEmpty) {
            return CircularProgressIndicator(color: cColor.black);
          }
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              _rewardList.length,
              (index) {
                return GestureDetector(
                  onTap: () => widget.bloc.filterPostsByReward(index),
                  child: Stack(
                    alignment: const Alignment(0.6, -1),
                    children: [
                      Container(
                        width: Dimensions.height5 * 14,
                        margin: EdgeInsets.only(right: Dimensions.width5 * 2),
                        child: Column(
                          children: [
                            // 圖片
                            ValueListenableBuilder(
                                valueListenable:
                                    widget.bloc.selectFilterNotifier,
                                builder: (context, value, child) {
                                  bool _isSelected = value == index;
                                  return Container(
                                    height: Dimensions.height2 * 27,
                                    width: Dimensions.height2 * 27,
                                    padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height5 * 1,
                                      horizontal: Dimensions.height5 * 1,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: _isSelected
                                          ? cColor.sub
                                          : cColor.white,
                                    ),
                                    child: SizedBox(
                                      height: Dimensions.height2 * 20,
                                      child: index == 0
                                          ? AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color: cColor.black,
                                                ),
                                              ),
                                            )
                                          : AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      _rewardList[index].pic,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  );
                                }),
                            SizedBox(height: Dimensions.height5),
                            // 文字
                            MediumText(
                              color: cColor.grey500,
                              size: Dimensions.height2 * 6,
                              text: _rewardList[index].name,
                              maxLines: 2,
                            ),
                            SizedBox(width: Dimensions.width2),
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: widget
                            .bloc.postLengthFromReward[_rewardList[index].id]!,
                        builder: (
                          context,
                          dynamic value,
                          Widget? child,
                        ) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width5,
                            ),
                            decoration: BoxDecoration(
                              color: cColor.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: MediumText(
                              color: Colors.white,
                              size: Dimensions.height2 * 6,
                              text: value.toString(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
