import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/models/reward_tag_model.dart';
import '../../globals/medium_text.dart';

class RewardBodyFilter extends StatefulWidget {
  final HomePageBloc bloc;
  final List<RewardTagModel> rewardList;
  final String searchText;
  const RewardBodyFilter({
    super.key,
    required this.bloc,
    required this.rewardList,
    required this.searchText,
  });

  @override
  State<RewardBodyFilter> createState() => _RewardBodyFilterState();
}

class _RewardBodyFilterState extends State<RewardBodyFilter> {
  late String searchText = widget.searchText;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        customButton: Container(
          height: 56,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width2 * 6,
          ),
          decoration: BoxDecoration(
            color: cColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              MediumText(
                color: cColor.grey500,
                size: Dimensions.height2 * 8,
                text: searchText,
              ),
              const Expanded(child: Column(children: [])),
              Icon(
                Icons.keyboard_arrow_down,
                color: cColor.grey400,
                size: Dimensions.height2 * 13,
              ),
            ],
          ),
        ),
        hint: MediumText(
          color: cColor.grey500,
          size: Dimensions.height2 * 8,
          text: "全部",
        ),
        value: searchText,
        isExpanded: true,
        onChanged: (value) {
          int _i = widget.rewardList.indexWhere((e) => e.name == value);
          if (_i == 0) {
            widget.bloc.filterOriginList(1);
          } else {
            widget.bloc.filterPostsByReward(
              widget.rewardList[_i].id,
            );
          }
          setState(() {
            searchText = value ?? "";
          });
        },
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.height2 * 6,
            horizontal: Dimensions.width2 * 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cColor.white,
          ),
          offset: const Offset(0, 8),
        ),
        items: widget.rewardList
            .map(
              (e) => DropdownMenuItem<String>(
                value: e.name,
                child: Row(
                  children: [
                    e.id == "all"
                        ? Container(
                            width: Dimensions.width2 * 16,
                            height: Dimensions.height2 * 16,
                            decoration: BoxDecoration(
                              border: Border.all(color: cColor.black),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: cColor.black,
                              ),
                            ),
                          )
                        : Container(
                            width: Dimensions.width2 * 16,
                            height: Dimensions.height2 * 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image: NetworkImage(e.pic),
                                  fit: BoxFit.cover),
                            ),
                          ),
                    SizedBox(width: Dimensions.width2 * 6),
                    MediumText(
                      color: cColor.grey500,
                      size: Dimensions.height2 * 7,
                      text: e.name,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
