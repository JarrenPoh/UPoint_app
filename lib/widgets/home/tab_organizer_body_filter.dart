import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import '../../bloc/tab_organizer_bloc.dart';
import '../../globals/medium_text.dart';
import '../../models/organizer_model.dart';

class TabOrganizerBodyFilter extends StatefulWidget {
  final TabOrganizerBloc bloc;
  const TabOrganizerBodyFilter({
    super.key,
    required this.bloc,
  });

  @override
  State<TabOrganizerBodyFilter> createState() => _TabOrganizerBodyFilterState();
}

class _TabOrganizerBodyFilterState extends State<TabOrganizerBodyFilter> {
  String searchText = "全部";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    return Container(
      height: Dimensions.height5 * 17,
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.height2 * 6,
      ),
      decoration: BoxDecoration(
        color: cColor.white,
      ),
      child: ValueListenableBuilder(
        valueListenable: widget.bloc.organListNotifier,
        builder: (context, value, child) {
          List<OrganizerModel> _organList = value;
          if (_organList.isEmpty) {
            return CircularProgressIndicator(color: cColor.black);
          }
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              _organList.length,
              (index) {
                return GestureDetector(
                  onTap: () => widget.bloc.filterPostsByOrganizer(index),
                  child: Stack(
                    alignment: const Alignment(0.6, -1),
                    children: [
                      Container(
                        width: Dimensions.height5 * 14,
                        margin: EdgeInsets.only(right: Dimensions.width5 * 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 照片
                            Container(
                              height: Dimensions.height2 * 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                                        height: Dimensions.height2 * 32,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              _organList[index].pic,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(height: Dimensions.height5),
                            // 字
                            ValueListenableBuilder(
                                valueListenable:
                                    widget.bloc.selectFilterNotifier,
                                builder: (context, value, child) {
                                  bool _isSelected = value == index;
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width5,
                                      vertical: Dimensions.height2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isSelected
                                          ? cColor.sub
                                          : cColor.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: MediumText(
                                      color: cColor.grey500,
                                      size: Dimensions.height2 * 6,
                                      text: _organList[index].username,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: widget
                            .bloc.postLengthFromOrgan[_organList[index].uid]!,
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
                              color: cColor.white,
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
