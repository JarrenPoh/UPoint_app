import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/pages/post_detail_page.dart';
import '../../globals/date_time_transfer.dart';
import '../../globals/medium_text.dart';
import '../../globals/scroll_things_provider.dart';
import '../../models/organizer_model.dart';
import '../../models/post_model.dart';
import '../custom_loading2.dart';

class OrganizerProfilePost extends StatefulWidget {
  final OrganizerModel organizer;
  final int index;
  const OrganizerProfilePost({
    super.key,
    required this.organizer,
    required this.index,
  });

  @override
  State<OrganizerProfilePost> createState() => _OrganizerProfilePostState();
}

class _OrganizerProfilePostState extends State<OrganizerProfilePost>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  late CColor cColor = CColor.of(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller:
          CustomScrollProviderData.of(context).scrollControllers[widget.index],
      slivers: [
        SliverToBoxAdapter(
          child: FutureBuilder<List<PostModel>>(
            future: FirestoreMethods()
                .fetchOrganizePost(organizerUid: widget.organizer.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomLoadong2();
              } else if (snapshot.hasData) {
                List<PostModel> postList = snapshot.data!;
                if (postList.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: Dimensions.height5 * 10),
                        MediumText(
                            color: cColor.grey500, size: 16, text: "沒有舉辦過活動"),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    SizedBox(height: Dimensions.height2 * 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(postList.length, (index) {
                        PostModel post = postList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PostDetailPage(
                                  post: post,
                                  hero: "organizer_profile_post${post.postId}");
                            }));
                          },
                          child: Container(
                            height: Dimensions.height2 * 56.5,
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height2 * 6,
                              horizontal: Dimensions.width2 * 16,
                            ),
                            child: Row(
                              children: [
                                Hero(
                                  tag: "organizer_profile_post${post.postId}",
                                  child: SizedBox(
                                    width: Dimensions.width2 * 74,
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        width: Dimensions.width2 * 74,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(post.photo!),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimensions.width2 * 4),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 標題
                                      MediumText(
                                        color: cColor.grey500,
                                        size: 14,
                                        text: post.title!,
                                        maxLines: 2,
                                      ),
                                      // 時間
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            size: Dimensions.height2 * 9,
                                            color: cColor.grey400,
                                          ),
                                          SizedBox(
                                              width: Dimensions.width2 * 4),
                                          MediumText(
                                            color: cColor.grey500,
                                            size: 13,
                                            text: TimeTransfer.timeTrans05(
                                              post.startDateTime,
                                              post.endDateTime,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // 獎勵
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_play,
                                            size: Dimensions.height2 * 9,
                                            color: cColor.grey400,
                                          ),
                                          SizedBox(
                                              width: Dimensions.width2 * 4),
                                          SizedBox(
                                            width: Dimensions.width2 * 65,
                                            child: MediumText(
                                              color: cColor.grey500,
                                              size: 13,
                                              text: post.reward ?? "無",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}
