import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:upoint/bloc/tab_act_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/widgets/home/drop_down_filter.dart';

import '../../models/filter_model.dart';

class FilterActBody extends StatefulWidget {
  final TabActBloc bloc;
  const FilterActBody({
    super.key,
    required this.bloc,
  });

  @override
  State<FilterActBody> createState() => _FilterActBodyState();
}

class _FilterActBodyState extends State<FilterActBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(vertical: Dimensions.height2 * 4),
          child: Column(
            children: [
              Row(
                children: List.generate(
                  widget.bloc.filterList.length,
                  (index) {
                    FilterModel filterModel = widget.bloc.filterList[index];
                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: DropDownFilter(
                              filterModel: filterModel,
                              onChanged: (e) {
                                filterModel.filter = e!;
                                widget.bloc.filter();
                              },
                            ),
                          ),
                          if (!(index == widget.bloc.filterList.length - 1))
                            SizedBox(width: Dimensions.width2 * 4),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
