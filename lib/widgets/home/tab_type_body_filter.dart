import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/tab_type_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import '../../globals/medium_text.dart';

class TabTypeBodyFilter extends StatefulWidget {
  final TabTypeBloc bloc;
  const TabTypeBodyFilter({
    super.key,
    required this.bloc,
  });

  @override
  State<TabTypeBodyFilter> createState() => _TabTypeBodyFilterState();
}

class _TabTypeBodyFilterState extends State<TabTypeBodyFilter> {
  String searchText = "全部";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.height2 * 6,
      ),
      decoration: BoxDecoration(
        color: cColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
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
                  size: 14,
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
            size: 12,
            text: "全部",
          ),
          value: searchText,
          isExpanded: true,
          onChanged: (value) {
            int _i = widget.bloc.typeList.indexWhere((e) => e == value);
            if (_i == 0) {
              widget.bloc.filterOriginList();
            } else {
              widget.bloc.filterPostsByType(
                widget.bloc.typeList[_i],
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
          items: widget.bloc.typeList
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.width2 * 6),
                      MediumText(
                        color: cColor.grey500,
                        size: 14,
                        text: e,
                      ),
                      SizedBox(width: Dimensions.width5 * 2),
                      ValueListenableBuilder(
                        valueListenable: widget.bloc.postLengthFromType[e]!,
                        builder: (
                          context,
                          dynamic value,
                          Widget? child,
                        ) {
                          return MediumText(
                            color: cColor.primary,
                            size: 10,
                            text: value.toString(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
