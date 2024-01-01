import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/organizer_model.dart';
import 'package:upoint/models/post_model.dart';
import 'package:provider/provider.dart';
import 'package:upoint/pages/activity_page.dart';
import 'package:upoint/pages/add_post_page.dart';
import 'package:upoint/global_key.dart' as globals;

class PostCard extends StatefulWidget {
  final PostModel post;
  final OrganModel? organizer;
  final String hero;
  final bool isOrganizer;
  const PostCard({
    super.key,
    required this.post,
    required this.hero,
    required this.isOrganizer,
    required this.organizer,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
    isOver = isOverTime(
      widget.post.endTime!,
      widget.post.date.toDate(),
    );
  }

  double _scale = 1.0;
  bool isOver = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTapDown: (d) => setState(() {
      //   _scale = 0.95;
      // }),
      onTapUp: (d) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityPage(
              post: widget.post,
              hero: widget.hero,
            ),
          ),
        );
        // setState(() {
        //   _scale = 1.0;
        // });
      },
      // onTapCancel: () => setState(() {
      //   _scale = 1.0;
      // }),
      child: Transform.scale(
        scale: _scale,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.height5 * 2,
          ),
          child: PostCard(
            widget.post.photos!.first,
            widget.post.title,
            widget.post.organizer,
            widget.post.datePublished,
            widget.post.startTime,
            widget.post.endTime,
          ),
        ),
      ),
    );
  }

  Widget PostCard(imageUrl, title, organizer, date, startTime, endTime) {
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
                              size: 16,
                              text: widget.post.reward!,
                            ),
                          ),
                        )
                      : Container(),
                  widget.isOrganizer && !isOver
                      ? Positioned(
                          right: 0,
                          top: Dimensions.height2 * 7,
                          child: CupertinoButton(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width5 * 4,
                                vertical: Dimensions.height5,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const MediumText(
                                    color: Colors.white,
                                    size: 16,
                                    text: '編輯',
                                  ),
                                  SizedBox(width: Dimensions.width5),
                                  Icon(
                                    Icons.edit,
                                    color: onSecondary,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                            onPressed: () {
                              final AddPostPageBloc bloc = AddPostPageBloc();
                              Provider.of<AddPostPageBloc>(context,
                                      listen: false)
                                  .updateCart(widget.post);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AddPostPage(
                                      backToHome: () {
                                        Navigator.pop(context);
                                        globals.globalManagePage!.currentState!
                                            .updatePost(widget.post.postId);
                                      },
                                      organizer: widget.organizer,
                                      isEdit: widget.isOrganizer,
                                      bloc: bloc,
                                    );
                                  },
                                ),
                              );
                            },
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
                          child: const Center(
                            child: MediumText(
                              color: Colors.white,
                              size: 16,
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
                    child: Text(
                      title,
                      style: TextStyle(
                        color: onSecondary,
                        fontSize: Dimensions.height2 * 8,
                        fontFamily: "NotoSansMedium",
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height5 * 2),
                  Container(
                    width: Dimensions.screenWidth * 0.55,
                    child: Text(
                      organizer,
                      style: TextStyle(
                        color: hintColor,
                        fontSize: Dimensions.height2 * 7,
                        fontFamily: "NotoSansMedium",
                      ),
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
                    formatTimestamp(date),
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
