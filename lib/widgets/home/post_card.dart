import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/pages/activity_page.dart';

class PostCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String organizer;
  const PostCard({
    super.key,
    required this.imageUrl,
    required this.organizer,
    required this.title,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) => setState(() {
        _scale = 0.95;
      }),
      onTapUp: (d) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityPage(
              imageUrl: widget.imageUrl,
              title: widget.title,
              organizer: widget.organizer,
            ),
          ),
        );
        setState(() {
          _scale = 1.0;
        });
      },
      onTapCancel: () => setState(() {
        _scale = 1.0;
      }),
      child: Transform.scale(
        scale: _scale,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.height5 * 2,
          ),
          child: PostCard(
            widget.imageUrl,
            widget.title,
          ),
        ),
      ),
    );
  }

  Widget PostCard(imageUrl, title) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color hintColor = Theme.of(context).hintColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: ((context, imageProvider) {
            return Hero(
              transitionOnUserGestures: true,
              tag: title,
              child: Stack(
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
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
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
                  Positioned(
                    right: 0,
                    top: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width5 * 4,
                        vertical: Dimensions.height5,
                      ),
                      decoration: BoxDecoration(
                        color: hintColor.withOpacity(.65),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: MediumText(
                        color: Colors.white,
                        size: 16,
                        text: '麥當勞折價券',
                      ),
                    ),
                  ),
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
                      widget.title,
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
                      widget.organizer,
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
                    '11月5日(三)',
                    style: TextStyle(
                      color: onSecondary,
                      fontSize: Dimensions.height2 * 7,
                      fontFamily: "NotoSansMedium",
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height5 * 2),
                Text(
                  '12:00-20:00',
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
