import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/organizer_model.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/pages/activity_detail_page.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final OrganizerModel? organizer;
  final String hero;
  final bool isOrganizer;
  final UserModel? user;
  const PostCard({
    super.key,
    required this.post,
    required this.hero,
    required this.isOrganizer,
    required this.organizer,
    required this.user,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
    isOver = (widget.post.endDateTime as Timestamp)
        .toDate()
        .isBefore(DateTime.now());
  }

  double _scale = 1.0;
  late bool isOver;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (d) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailPage(
              post: widget.post,
              hero: widget.hero,
              user: widget.user,
            ),
          ),
        );
      },
      child: Transform.scale(
        scale: _scale,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.height5 * 2,
          ),
          child: PostCard(
            widget.post.photo,
            widget.post.title,
            widget.post.organizerName,
            widget.post.startDateTime,
            widget.post.endDateTime,
          ),
        ),
      ),
    );
  }

  Widget PostCard(
    imageUrl,
    title,
    organizerName,
    Timestamp startTime,
    Timestamp endTime,
  ) {
    CColor cColor = CColor.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: ((context, imageProvider) {
            return Hero(
              transitionOnUserGestures: true,
              tag: widget.hero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      height: Dimensions.height5 * 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                      // child: Container(
                      //   decoration: BoxDecoration(
                      //     color: isOver ? Colors.black.withOpacity(0.8) : null,
                      //     borderRadius: BorderRadius.circular(20),
                      //     gradient: isOver
                      //         ? null
                      //         : LinearGradient(
                      //             begin: Alignment.bottomRight,
                      //             stops: const [0.3, 0.9],
                      //             colors: [
                      //               Colors.black.withOpacity(.8),
                      //               Colors.black.withOpacity(.2),
                      //             ],
                      //           ),
                      //   ),
                      // ),
                    ),
                  ),
                  widget.post.reward != null
                      ? Positioned(
                          left: 0,
                          top: Dimensions.height2 * 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width5 * 4,
                              vertical: Dimensions.height5,
                            ),
                            decoration: BoxDecoration(
                              color: cColor.primary.withOpacity(.65),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: MediumText(
                              color: cColor.grey500,
                              size: Dimensions.height2 * 8,
                              text: widget.post.reward!,
                            ),
                          ),
                        )
                      : Container(),
                  isOver
                      ? Container(
                          width: Dimensions.width5 * 25,
                          height: Dimensions.height5 * 8,
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width5 * 4,
                            vertical: Dimensions.height5,
                          ),
                          decoration: BoxDecoration(
                            color: cColor.primary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: MediumText(
                              color: cColor.grey500,
                              size: Dimensions.height2 * 8,
                              text: '活動已結束',
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            );
          }),
          placeholder: (context, url) => SizedBox(
            height: Dimensions.height5 * 3,
            width: Dimensions.height5 * 3,
            child: const CircularProgressIndicator.adaptive(
              backgroundColor: Colors.grey,
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        SizedBox(height: Dimensions.height5 * 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: Dimensions.width2 * 5),
            SizedBox(
              width: Dimensions.screenWidth * 0.45,
              height: Dimensions.height5 * 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MediumText(
                    color: cColor.grey500,
                    size: Dimensions.height2 * 8,
                    text: widget.post.title!,
                  ),
                  SizedBox(height: Dimensions.height5 * 1),
                  MediumText(
                    color: cColor.primary,
                    size: Dimensions.height2 * 7,
                    text: organizerName,
                  ),
                ],
              ),
            ),
            Expanded(child: Column(children: [])),
            SizedBox(
              height: Dimensions.height5 * 10,
              width: Dimensions.screenWidth * 0.4,
              child: MediumText(
                maxLines: 2,
                color: cColor.grey500,
                size: Dimensions.height2 * 7,
                text: TimeTransfer.timeTrans03(startTime, endTime),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
