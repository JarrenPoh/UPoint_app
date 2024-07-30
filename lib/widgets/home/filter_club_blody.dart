import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/models/organizer_model.dart';
import '../../bloc/tab_club_bloc.dart';
import '../../globals/dimension.dart';
import '../../globals/medium_text.dart';

class FilterClubBody extends StatefulWidget {
  final TabClubBloc bloc;
  const FilterClubBody({
    super.key,
    required this.bloc,
  });

  @override
  State<FilterClubBody> createState() => _FilterClubBodyState();
}

class _FilterClubBodyState extends State<FilterClubBody> {
  late final CColor cColor = CColor.of(context);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.height5 * 33,
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height2 * 3,
        horizontal: Dimensions.width2 * 4,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: Dimensions.height5 * 4,
                width: Dimensions.width5 * 4,
                child: Icon(Icons.location_on, color: cColor.grey500),
              ),
              SizedBox(width: Dimensions.width2 * 4),
              MediumText(
                color: cColor.grey500,
                size: 16,
                text: "中原大學",
              ),
              const Expanded(child: Column(children: [])),
              Container(
                height: Dimensions.height2 * 15,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width2 * 4,
                  vertical: Dimensions.height2 * 3,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: cColor.primary),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: MediumText(
                  color: cColor.primary,
                  size: 12,
                  text: "所有社團",
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: List.generate(
                widget.bloc.organizerList.length,
                (index) {
                  OrganizerModel model = widget.bloc.organizerList[index];
                  return SizedBox(
                    width: Dimensions.width2 * 32,
                    height: Dimensions.height2 * 51,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: const Alignment(1, -1),
                                children: [
                                  SizedBox(
                                    height: Dimensions.height2 * 24,
                                    width: Dimensions.width2 * 24,
                                    child: index == 0
                                        ? Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: cColor.grey200),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: cColor.black,
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  model.pic,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: widget.bloc.countNotifier,
                                    builder: (context, dynamic value,
                                        Widget? child) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions.width5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: cColor.primary,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: MediumText(
                                          color: Colors.white,
                                          size: Dimensions.height2 * 6,
                                          text: value[model.username].toString(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () =>
                              widget.bloc.filterPostsByOrganizer(index),
                          child: ValueListenableBuilder(
                            valueListenable: widget.bloc.selectFilterNotifier,
                            builder: (context, value, child) {
                              bool _isSelected = value == index;
                              return Container(
                                height: Dimensions.height2 * 17,
                                width: Dimensions.width2 * 32,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width2 * 3,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _isSelected ? cColor.sub : cColor.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: MediumText(
                                      color: cColor.grey500,
                                      size: 12,
                                      text: model.username,
                                      maxLines: 3,
                                      textAlign: TextAlign.center),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
