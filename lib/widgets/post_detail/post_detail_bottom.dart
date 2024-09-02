import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/post_detail_page_bloc.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/pages/login_page.dart';
import 'package:upoint/pages/sign_form_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../globals/colors.dart';
import '../../globals/dimension.dart';
import '../../globals/medium_text.dart';

class PostDetailBottomBar extends StatefulWidget {
  final PostModel post;
  final PostDetailPageBloc bloc;
  final UserModel? user;
  const PostDetailBottomBar({
    super.key,
    required this.post,
    required this.bloc,
    required this.user,
  });

  @override
  State<PostDetailBottomBar> createState() => _PostDetailBottomBarState();
}

class _PostDetailBottomBarState extends State<PostDetailBottomBar> {
  late CColor cColor;
  bool isOver = false;
  bool needSign = true;
  bool alreadySign = false;
  bool isFull = false;
  @override
  void initState() {
    super.initState();
    initInform();
  }

  initInform() {
    alreadySign = widget.user?.signList == null
        ? false
        : widget.user!.signList!.contains(widget.post.postId);
    isFull = widget.post.capacity == null
        ? false
        : widget.post.capacity! <= widget.post.signFormsLength!.toInt();
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
    initInform();
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
                () => onTap(
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
                  onTap(
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

  onTap(
    bool _isSign,
    BuildContext context,
    PostModel post,
    UserModel? user,
  ) async {
    // CColor cColor = CColor.of(context);
    if (_isSign) {
      // 需要報名，先判斷外部還內部
      if (post.form?.substring(0, 4) == "http") {
        debugPrint("前進外部報名");
        final String url = post.form!;
        await launch(url);
      } else {
        if (user == null) {
          String res = await Messenger.dialog(
            '請先登入',
            '您尚未登入帳戶',
            context,
          );
          if (res == "success") {
            // ignore: use_build_context_synchronously
            //配置路由
            // Provider.of<UriBloc>(context, listen: false).setUri(
            //   Uri(
            //     pathSegments: ['activity'],
            //     queryParameters: {"id": post.postId!},
            //   ),
            // );
            // ignore: use_build_context_synchronously
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        } else {
          debugPrint("前進本地報名");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SignFormPage(
                  post: post,
                  user: user,
                );
              },
            ),
          );
        }
      }
    } else {
      if (post.link != null) {
        final String url = post.link!;
        await launch(url);
      }
    }
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
