import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/activity_detail_page_bloc.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import '../../globals/colors.dart';
import '../../globals/dimension.dart';
import '../../globals/medium_text.dart';

class ActDetailBottomBar extends StatefulWidget {
  final PostModel post;
  final ActivityDetailPageBloc bloc;
  final UserModel? user;
  const ActDetailBottomBar({
    super.key,
    required this.post,
    required this.bloc,
    required this.user,
  });

  @override
  State<ActDetailBottomBar> createState() => _ActDetailBottomBarState();
}

class _ActDetailBottomBarState extends State<ActDetailBottomBar> {
  late CColor cColor;
  bool isOver = false;
  bool needSign = true;
  late bool alreadySign = widget.user?.signList == null
      ? false
      : widget.user!.signList!.contains(widget.post.postId);
  late bool isFull = widget.post.capacity == null
      ? false
      : widget.post.capacity! <= widget.post.signFormsLength!.toInt();
  @override
  void initState() {
    super.initState();
    if (widget.post.form == null) {
      needSign = false;
    }
    if (widget.post.formDateTime != null) {
      isOver = (widget.post.formDateTime as Timestamp)
          .toDate()
          .isBefore(DateTime.now());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cColor = CColor.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: cColor.white,
        ),
        padding: EdgeInsets.only(
          bottom: 0,
          left: Dimensions.width2 * 8,
          right: Dimensions.width2 * 8,
        ),
        height: Dimensions.height5 * 12.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.post.link != null && widget.post.link!.isNotEmpty)
              _buttonWidget(
                () => widget.bloc.onTap(
                  false,
                  context,
                  widget.post,
                  widget.user,
                ),
                "更多活動資訊",
                Colors.white,
                false,
              ),
            if (widget.post.link != null && widget.post.link!.isNotEmpty)
              SizedBox(width: Dimensions.width5 * 2),
            _buttonWidget(
              () {
                if (!isOver && needSign && !alreadySign && !isFull) {
                  widget.bloc.onTap(
                    true,
                    context,
                    widget.post,
                    widget.user,
                  );
                }
              },
              !needSign
                  ? "無需報名"
                  : isOver
                      ? "報名已結束"
                      : alreadySign
                          ? "已經報名"
                          : isFull
                              ? "報名已額滿"
                              : "報名",
              (isOver || !needSign || alreadySign || isFull)
                  ? cColor.grey200
                  : cColor.primary,
              true,
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonWidget(Function onTap, String text, Color color, bool isSign) {
    return Expanded(
      child: SizedBox(
        height: Dimensions.height2 * 22,
        child: CupertinoButton(
          color: color,
          onPressed: () => onTap(),
          pressedOpacity: 0.8,
          padding: const EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSign ? Colors.transparent : cColor.primary,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: MediumText(
                color: isSign ? Colors.white : cColor.primary,
                size: Dimensions.height2 * 8,
                text: text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
