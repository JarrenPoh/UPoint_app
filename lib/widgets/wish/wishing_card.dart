// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:upoint/bloc/wishing_bloc.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/models/wish_model.dart';

import '../../globals/colors.dart';
import '../../globals/custom_messengers.dart';
import '../../globals/dimension.dart';
import '../../globals/medium_text.dart';
import '../../globals/regular_text.dart';
import '../../pages/login_page.dart';
import 'heart_animation_widget.dart';

class WishingCard extends StatefulWidget {
  final WishModel wish;
  final UserModel? user;
  final WishingBloc bloc;
  const WishingCard({
    super.key,
    required this.wish,
    required this.user,
    required this.bloc,
  });

  @override
  State<WishingCard> createState() => _WishingCardState();
}

class _WishingCardState extends State<WishingCard> {
  bool isHeartAnimating = false;
  onDoubleTap() async {
    if (widget.user == null) {
      String res = await Messenger.dialog(
        '請先登入',
        '您尚未登入帳戶',
        context,
      );
      if (res == "success") {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } else {
      setState(() {
        if (!widget.wish.rateList.contains(widget.user?.uuid)) {
          widget.bloc.likeWish(context, widget.user!, widget.wish);
          isHeartAnimating = true;
          widget.wish.rateList.add(widget.user?.uuid);
        }
      });
    }
  }

  ontap() async {
    if (widget.user == null) {
      String res = await Messenger.dialog(
        '請先登入',
        '您尚未登入帳戶',
        context,
      );
      if (res == "success") {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } else {
      widget.bloc.likeWish(context, widget.user!, widget.wish);
      setState(() {
        if (!widget.wish.rateList.contains(widget.user?.uuid)) {
          widget.wish.rateList.add(widget.user?.uuid);
        } else {
          widget.wish.rateList.removeWhere((e) => e == widget.user?.uuid);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    late bool isLike = widget.user == null
        ? false
        : widget.wish.rateList.contains(widget.user!.uuid);
    return GestureDetector(
      onDoubleTap: () => onDoubleTap(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height2 * 6,
              horizontal: Dimensions.width2 * 6,
            ),
            margin: EdgeInsets.only(
              bottom: Dimensions.height2 * 7,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: cColor.grey200),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 日期
                    MediumText(
                      color: cColor.grey400,
                      size: Dimensions.height2 * 7,
                      text: TimeTransfer.timeTrans06(widget.wish.datePublished),
                    ),
                    // 按讚
                    GestureDetector(
                      onTap: () => ontap(),
                      child: Row(
                        children: [
                          Icon(
                            isLike ? Icons.favorite : Icons.favorite_outline,
                            color: isLike ? cColor.primary : cColor.grey400,
                            size: Dimensions.height2 * 8,
                          ),
                          SizedBox(width: Dimensions.width5),
                          MediumText(
                            color: isLike ? cColor.primary : cColor.grey400,
                            size: Dimensions.height2 * 7,
                            text: widget.wish.rateList.length.toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height2 * 2),
                // 內容
                RegularText(
                  color: cColor.grey500,
                  size: Dimensions.height2 * 8,
                  maxLines: 5,
                  text: widget.wish.content,
                ),
              ],
            ),
          ),
          Opacity(
            opacity: isHeartAnimating ? 1 : 0,
            child: HeartAnimationWidget(
              isAnimating: isHeartAnimating,
              child: Icon(
                Icons.favorite,
                color: cColor.primary,
                size: Dimensions.height5 * 10,
              ),
              onEnd: () => setState(() => isHeartAnimating = false),
            ),
          ),
        ],
      ),
    );
  }
}
