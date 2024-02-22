import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:upoint/models/post_model.dart';
import '../../globals/colors.dart';
import '../../globals/dimension.dart';

class PostDetailAppBar extends StatefulWidget {
  final PostModel post;
  final String hero;
  const PostDetailAppBar({
    super.key,
    required this.hero,
    required this.post,
  });

  @override
  State<PostDetailAppBar> createState() => _PostDetailAppBarState();
}

class _PostDetailAppBarState extends State<PostDetailAppBar> {
  late CColor cColor;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cColor = CColor.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: Dimensions.height5 * 46,
      elevation: 0,
      snap: true,
      floating: true,
      stretch: true,
      backgroundColor: cColor.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          width: Dimensions.height2 * 23,
          height: Dimensions.height2 * 23,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: cColor.white,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.chevron_left_outlined,
              color: cColor.black,
              size: Dimensions.height2 * 18,
            ),
          ),
        ),
      ),
      actions: [
        // IconButton(
        //   padding: EdgeInsets.all(0),
        //   onPressed: () async {
        //     String postLink = 'https://$host/activity/?id=${widget.post.postId}';
        //     try {
        //       await Share.share(
        //         ' - ${widget.post.title} ${widget.post.organizerName}\n$postLink',
        //         subject: '${widget.post.title}  ${widget.post.content!}...',
        //       );
        //     } catch (e) {
        //       print(e.toString());
        //     }
        //   },
        //   icon: Container(
        //     width: Dimensions.height2 * 20,
        //     height: Dimensions.height2 * 20,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(40),
        //       color: cColor.primary,
        //     ),
        //     child: Icon(
        //       Icons.share,
        //       color: Colors.white,
        //       size: Dimensions.height2 * 12,
        //     ),
        //   ),
        // ),
      ],
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground
        ],
        background: Hero(
          transitionOnUserGestures: true,
          tag: widget.hero,
          child: CachedNetworkImage(
            imageUrl: widget.post.photo!,
            imageBuilder: ((context, imageProvider) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                      // child: Container(
                      //   decoration: BoxDecoration(
                      //     color: widget.isOver
                      //         ? Colors.black.withOpacity(0.8)
                      //         : null,
                      //     borderRadius: BorderRadius.circular(0),
                      //     gradient: widget.isOver
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
                ],
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
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height2 * 14.4),
        child: Container(
          height: Dimensions.height2 * 14.4,
          decoration: BoxDecoration(
            color: cColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            border: Border(
              bottom: BorderSide(color: cColor.div),
            ),
          ),
          child: Center(
            child: Container(
              width: Dimensions.width5 * 10,
              height: Dimensions.height2 * 4,
              decoration: BoxDecoration(
                color: cColor.grey200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
