import 'package:flutter/material.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/widgets/custom_picker.dart';
import 'package:upoint/widgets/edit_choose.dart';
import 'package:upoint/widgets/edit_textfield.dart';
import 'package:provider/provider.dart';

class AddOther extends StatefulWidget {
  final AddPostPageBloc bloc;
  final bool isEdit;
  const AddOther({
    super.key,
    required this.bloc,
    required this.isEdit,
  });

  @override
  State<AddOther> createState() => _AddOtherState();
}

class _AddOtherState extends State<AddOther>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        PostModel cart =
            Provider.of<AddPostPageBloc>(context, listen: false).cart;
        widget.bloc.linkController.text = cart.link ?? '';
        widget.bloc.rewardController.text = cart.reward ?? '';
      });
    }
  }

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
        maxLength: 40,
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
        maxLength: 20,
        maxLines: 1,
        onChanged: () {
          Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
            PostModel(reward: widget.bloc.rewardController.text),
          );
        },
      ),
      //rewardTagId
      ValueListenableBuilder(
        valueListenable: widget.bloc.rewardTagIdValueNotifier,
        builder: (context, value, child) {
          value as ChooseModel;
          return EditChoose(
            chose: value.chose,
            isChose: value.isChose,
            unit: widget.bloc.unitOfRewardTagId,
            onPressed: () => CustomPicker(
              context,
              widget.bloc.rewardTagIdList,
              value.initChose,
              value.chose,
              value.isChose,
              (v) {
                widget.bloc.rewardTagIdValueNotifier.ChooseModelChange(
                  ChooseModel(
                    chose: widget.bloc.rewardTagIdList[v].toString(),
                    isChose: true,
                    initChose: v,
                  ),
                );
                Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
                  PostModel(
                    rewardTagId: "00$v",
                  ),
                );
              },
            ),
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
