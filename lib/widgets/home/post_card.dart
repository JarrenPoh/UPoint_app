import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            " widget.post.date",
            "widget.post.startTime",
            "widget.post.endTime",
          ),
        ),
      ),
    );
  }

  Widget PostCard(imageUrl, title, organizerName, date, startTime, endTime) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color hintColor = Theme.of(context).hintColor;
    Color primaryColor = Theme.of(context).primaryColor;
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: isOver ? Colors.black.withOpacity(0.8) : null,
                          borderRadius: BorderRadius.circular(20),
                          gradient: isOver
                              ? null
                              : LinearGradient(
                                  begin: Alignment.bottomRight,
                                  stops: const [0.3, 0.9],
                                  colors: [
                                    Colors.black.withOpacity(.8),
                                    Colors.black.withOpacity(.2),
                                  ],
                                ),
                        ),
                      ),
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
                              color: hintColor.withOpacity(.65),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: MediumText(
                              color: Colors.white,
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
                            color: primaryColor.withOpacity(1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: MediumText(
                              color: Colors.white,
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
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.grey,
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        SizedBox(height: Dimensions.height5 * 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: Dimensions.width5 * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Dimensions.screenWidth * 0.55,
                    child: MediumText(
                      color: onSecondary,
                      size: Dimensions.height2 * 8,
                      text: title,
                    ),
                  ),
                  SizedBox(height: Dimensions.height5 * 2),
                  Container(
                    width: Dimensions.screenWidth * 0.55,
                    child: MediumText(
                      color: hintColor,
                      size: Dimensions.height2 * 7,
                      text: organizerName,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Column(children: [])),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Dimensions.screenWidth * 0.3,
                  child: Text(
                    "formatTimestamp(date)",
                    style: TextStyle(
                      color: onSecondary,
                      fontSize: Dimensions.height2 * 7,
                      fontFamily: "NotoSansMedium",
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height5 * 2),
                Text(
                  '$startTime-$endTime',
                  style: TextStyle(
                    color: onSecondary,
                    fontSize: Dimensions.height2 * 7,
                    fontFamily: "NotoSansMedium",
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
