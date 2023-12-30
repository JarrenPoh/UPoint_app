import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/widgets/custom_date_picker.dart';
import 'package:upoint/widgets/edit_choose.dart';
import 'package:upoint/widgets/edit_textfield.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/models/user_model.dart';
import 'package:provider/provider.dart';

class AddInformation extends StatefulWidget {
  final AddPostPageBloc bloc;
  const AddInformation({
    super.key,
    required this.bloc,
  });

  @override
  State<AddInformation> createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  List widgets = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    User? user = Provider.of<AuthMethods>(context, listen: false).user;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    if (user != null) {
      widget.bloc.organizerController.text = user.username ?? "";
    }
    widgets = [
      //主辦單位
      Container(
        margin: EdgeInsets.symmetric(
          vertical: Dimensions.height5 * 1,
          horizontal: Dimensions.width5 * 3,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width5 * 2,
          vertical: Dimensions.height5 * 3,
        ),
        child: IgnorePointer(
          child: TextField(
            controller: widget.bloc.organizerController,
            style: TextStyle(color: onSecondary),
            keyboardType: TextInputType.text,
            decoration: null,
          ),
        ),
      ),
      //日期
      ValueListenableBuilder(
        valueListenable: widget.bloc.dateValueNotifier,
        builder: (context, value, child) {
          value as ChooseModel;
          return EditChoose(
            chose: value.chose,
            isChose: value.isChose,
            unit: widget.bloc.unitOfDate,
            onPressed: () => CustomDatePicker(
              context,
              value.chose,
              value.isChose,
              (date) {
                widget.bloc.dateValueNotifier.ChooseModelChange(
                  ChooseModel(
                    chose: formatDate(date, true),
                    isChose: true, //沒用
                    initChose: 0, //沒用
                  ),
                );
                Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
                  PostModel(date: date),
                );
                //  檢查是否可以往下一頁
                widget.bloc.checkInform(
                    Provider.of<AddPostPageBloc>(context, listen: false).cart);
              },
              CupertinoDatePickerMode.date,
            ),
          );
        },
      ),
      // //開始時間
      ValueListenableBuilder(
        valueListenable: widget.bloc.startTimeValueNotifier,
        builder: (context, value, child) {
          value as ChooseModel;
          return EditChoose(
            chose: value.chose,
            isChose: value.isChose,
            unit: widget.bloc.startTime,
            onPressed: () => CustomDatePicker(
              context,
              value.chose,
              value.isChose,
              (time) {
                widget.bloc.startTimeValueNotifier.ChooseModelChange(
                  ChooseModel(
                    chose: formatDate(time, false),
                    isChose: true, //沒用
                    initChose: 0, //沒用
                  ),
                );
                Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
                  PostModel(startTime: formatDate(time, false)),
                );
                //  檢查是否可以往下一頁
                widget.bloc.checkInform(
                    Provider.of<AddPostPageBloc>(context, listen: false).cart);
              },
              CupertinoDatePickerMode.time,
            ),
          );
        },
      ),
      // //結束時間
      ValueListenableBuilder(
        valueListenable: widget.bloc.endTimeValueNotifier,
        builder: (context, value, child) {
          value as ChooseModel;
          return EditChoose(
            chose: value.chose,
            isChose: value.isChose,
            unit: widget.bloc.endTime,
            onPressed: () => CustomDatePicker(
              context,
              value.chose,
              value.isChose,
              (time) {
                widget.bloc.endTimeValueNotifier.ChooseModelChange(
                  ChooseModel(
                    chose: formatDate(time, false),
                    isChose: true, //沒用
                    initChose: 0, //沒用
                  ),
                );
                Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
                  PostModel(endTime: formatDate(time, false)),
                );
                //  檢查是否可以往下一頁
                widget.bloc.checkInform(
                    Provider.of<AddPostPageBloc>(context, listen: false).cart);
              },
              CupertinoDatePickerMode.time,
            ),
          );
        },
      ),
      //標題
      EditTextField(
        focusNode: widget.bloc.titleFocusNode,
        textEditingController: widget.bloc.titleController,
        isDone: widget.bloc.isTitle,
        maxLength: 10,
        maxLines: 1,
        onChanged: () {
          Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
            PostModel(title: widget.bloc.titleController.text),
          );
          //  檢查是否可以往下一頁
          widget.bloc.checkInform(
              Provider.of<AddPostPageBloc>(context, listen: false).cart);
        },
      ),
      //內容
      EditTextField(
        focusNode: widget.bloc.contentFocusNode,
        textEditingController: widget.bloc.contentController,
        isDone: widget.bloc.isContent,
        maxLength: 1000,
        maxLines: 30,
        onChanged: () {
          Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
            PostModel(content: widget.bloc.contentController.text),
          );
          //  檢查是否可以往下一頁
          widget.bloc.checkInform(
              Provider.of<AddPostPageBloc>(context, listen: false).cart);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //  短條
            GridView.custom(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              physics: const ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                childAspectRatio: 1.4,
                crossAxisSpacing: Dimensions.width5 * 0,
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
                    height: Dimensions.height5 * 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: Dimensions.width5 * 2),
                            if (widget.bloc.informations[index].values
                                    .toList()[1] ==
                                true)
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: Dimensions.height5 * 4,
                                ),
                              ),
                            SizedBox(width: Dimensions.width5),
                            MediumText(
                              color: Colors.grey,
                              size: Dimensions.height2 * 7.5,
                              text: widget.bloc.informations[index].values
                                  .toList()[0],
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height2 * 2),
                        widgets[index],
                        SizedBox(height: Dimensions.height5),
                      ],
                    ),
                  );
                },
                childCount: widget.bloc.informations.length - 2,
              ),
            ),
            //  標題
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              padding: EdgeInsets.only(
                right: Dimensions.width5 * 20,
                top: Dimensions.height5,
                bottom: Dimensions.height5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: Dimensions.width5 * 2),
                      if (widget.bloc.informations[4].values.toList()[1] ==
                          true)
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: Dimensions.height5 * 4,
                          ),
                        ),
                      SizedBox(width: Dimensions.width5),
                      MediumText(
                        color: Colors.grey,
                        size: Dimensions.height2 * 7.5,
                        text: widget.bloc.informations[4].values.toList()[0],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height2 * 2),
                  widgets[4],
                  SizedBox(height: Dimensions.height5),
                ],
              ),
            ),
            //  內容
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: Dimensions.width5 * 2),
                      if (widget.bloc.informations[5].values.toList()[1] ==
                          true)
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: Dimensions.height5 * 4,
                          ),
                        ),
                      SizedBox(width: Dimensions.width5),
                      MediumText(
                        color: Colors.grey,
                        size: Dimensions.height2 * 7.5,
                        text: widget.bloc.informations[5].values.toList()[0],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height2 * 2),
                  widgets[5],
                  SizedBox(height: Dimensions.height5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
