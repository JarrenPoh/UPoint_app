import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';

import '../../globals/medium_text.dart';
import '../../models/organizer_model.dart';

class ActivityBodyFilter extends StatefulWidget {
  final HomePageBloc bloc;
  final List<OrganizerModel> organList;
  final String searchText;
  const ActivityBodyFilter({
    super.key,
    required this.bloc,
    required this.organList,
    required this.searchText,
  });

  @override
  State<ActivityBodyFilter> createState() => _ActivityBodyFilterState();
}

class _ActivityBodyFilterState extends State<ActivityBodyFilter> {
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
          int _i = widget.organList.indexWhere((e) => e.username == value);
          if (_i == 0) {
            widget.bloc.filterOriginList(0);
          } else {
            widget.bloc.filterPostsByOrganizer(
              widget.organList[_i].uid,
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
        items: widget.organList
            .map(
              (e) => DropdownMenuItem<String>(
                value: e.username,
                child: Row(
                  children: [
                    e.uid == "all"
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
                      text: e.username,
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
