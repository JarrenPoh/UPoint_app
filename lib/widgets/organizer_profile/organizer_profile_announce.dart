import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/models/announce_model.dart';
import '../../firebase/firestore_methods.dart';
import '../../globals/date_time_transfer.dart';
import '../../globals/dimension.dart';
import '../../globals/medium_text.dart';
import '../../globals/scroll_things_provider.dart';
import '../../models/organizer_model.dart';
import '../custom_loading2.dart';

class OrganizerProfileAnnounce extends StatefulWidget {
  final OrganizerModel organizer;
  final int index;
  const OrganizerProfileAnnounce({
    super.key,
    required this.organizer,
    required this.index,
  });

  @override
  State<OrganizerProfileAnnounce> createState() =>
      _OrganizerProfileAnnounceState();
}

class _OrganizerProfileAnnounceState extends State<OrganizerProfileAnnounce>
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
          child: FutureBuilder<List<AnnounceModel>>(
            future: FirestoreMethods()
                .fetchOrganizeAnnounce(organizerUid: widget.organizer.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomLoadong2();
              } else if (snapshot.hasData) {
                List<AnnounceModel> announcements = snapshot.data!;
                if (announcements.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: Dimensions.height5 * 10),
                        MediumText(
                            color: cColor.grey500, size: 16, text: "沒有公告"),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    SizedBox(height: Dimensions.height2 * 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        announcements.length,
                        (index) {
                          AnnounceModel announce = announcements[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height2 * 6,
                              horizontal: Dimensions.width2 * 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 頭像名字
                                Row(
                                  children: [
                                    Container(
                                      width: Dimensions.width2 * 15,
                                      height: Dimensions.height2 * 15,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              announce.organizerPic),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width2 * 3),
                                    MediumText(
                                      color: cColor.grey500,
                                      size: 16,
                                      text: announce.organizerName,
                                    ),
                                    const Expanded(
                                        child: Column(
                                      children: [],
                                    )),
                                    // pin
                                    if (announce.isPin)
                                      SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: SvgPicture.asset(
                                          "assets/pin.svg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                                // 照片
                                if (announce.photo != null)
                                  SizedBox(height: Dimensions.height2 * 6),
                                if (announce.photo != null)
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(announce.photo!),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: Dimensions.height2 * 6),
                                // 內容&發布日期
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 內容
                                    MediumText(
                                      color: cColor.grey500,
                                      size: 16,
                                      text: announce.content,
                                      maxLines: 100,
                                    ),
                                    SizedBox(height: Dimensions.height2),
                                    // 發布日期
                                    MediumText(
                                      color: cColor.grey400,
                                      size: 12,
                                      text: TimeTransfer.timeTrans06(
                                        announce.datePublished,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimensions.height2 * 6),
                                // 點讚留言
                                Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_outline_rounded,
                                      color: cColor.grey400,
                                      size: 20,
                                    ),
                                    SizedBox(width: Dimensions.width2),
                                    MediumText(
                                      color: cColor.grey400,
                                      size: 14,
                                      text: announce.likes.length.toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
