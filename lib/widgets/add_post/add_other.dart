import 'package:flutter/material.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/widgets/edit_textfield.dart';
import 'package:provider/provider.dart';

class AddOther extends StatefulWidget {
  final AddPostPageBloc bloc;
  const AddOther({
    super.key,
    required this.bloc,
  });

  @override
  State<AddOther> createState() => _AddOtherState();
}

class _AddOtherState extends State<AddOther>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  List widgets = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    widgets = [
      //link
      EditTextField(
        focusNode: widget.bloc.linkFocusNode,
        textEditingController: widget.bloc.linkController,
        isDone: widget.bloc.isLink,
        maxLength: 10,
        maxLines: 1,
        onChanged: () {
          Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
            PostModel(link: widget.bloc.linkController.text),
          );
        },
      ),
      //reward
      EditTextField(
        focusNode: widget.bloc.rewardFocusNode,
        textEditingController: widget.bloc.rewardController,
        isDone: widget.bloc.isReward,
        maxLength: 10,
        maxLines: 1,
        onChanged: () {
          Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
            PostModel(reward: widget.bloc.rewardController.text),
          );
        },
      ),
    ];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            widget.bloc.others.length,
            (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: Dimensions.width5 * 2),
                      MediumText(
                        color: onSecondary,
                        size: Dimensions.height2 * 7.5,
                        text: widget.bloc.others[index].values.toList()[0],
                      ),
                      SizedBox(width: Dimensions.width5),
                      if (widget.bloc.others[index].values.toList()[1] == true)
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: Dimensions.height5 * 4,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height2 * 0),
                  widgets[index],
                  SizedBox(height: Dimensions.height5 * 2),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
