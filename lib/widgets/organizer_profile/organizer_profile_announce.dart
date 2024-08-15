import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/models/announce_model.dart';
import 'package:upoint/models/user_model.dart';
import '../../firebase/auth_methods.dart';
import '../../firebase/firestore_methods.dart';
import '../../globals/custom_messengers.dart';
import '../../globals/date_time_transfer.dart';
import '../../globals/dimension.dart';
import '../../globals/medium_text.dart';
import '../../globals/scroll_things_provider.dart';
import '../../models/organizer_model.dart';
import '../../pages/login_page.dart';
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

  Future<List<AnnounceModel>>? _announceFuture;

  @override
  void initState() {
    super.initState();
    // 初始化Future，只會執行一次
    _announceFuture = FirestoreMethods()
        .fetchOrganizeAnnounce(organizerUid: widget.organizer.uid);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller:
          CustomScrollProviderData.of(context).scrollControllers[widget.index],
      slivers: [
        SliverToBoxAdapter(
          child: FutureBuilder<List<AnnounceModel>>(
            future: _announceFuture, // 使用初始化後的Future
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
                return _buildAnnouncements(announcements, context);
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncements(
      List<AnnounceModel> announcements, BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimensions.height2 * 4),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width2 * 8,
          ),
          child: Consumer<AuthMethods>(builder: (context, userNotifier, child) {
            UserModel? user = userNotifier.user;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                announcements.length,
                (index) {
                  AnnounceModel announce = announcements[index];
                  bool isLike = announce.likes.contains(user?.uuid);
                  return GestureDetector(
                    onTap: () => _toggleLike(announce, user),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height2 * 6,
                        horizontal: Dimensions.width2 * 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(announce),
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
                          _buildContent(announce),
                          SizedBox(height: Dimensions.height2 * 6),
                          _buildLikeSection(announce, isLike),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeader(AnnounceModel announce) {
    return Row(
      children: [
        Container(
          width: Dimensions.width2 * 12,
          height: Dimensions.height2 * 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(announce.organizerPic),
            ),
          ),
        ),
        SizedBox(width: Dimensions.width2 * 6),
        MediumText(
          color: cColor.grey500,
          size: 14,
          text: announce.organizerName,
        ),
        const Expanded(child: Column(children: [])),
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
    );
  }

  Widget _buildContent(AnnounceModel announce) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumText(
          color: cColor.grey500,
          size: 16,
          text: announce.content,
          maxLines: 100,
        ),
        SizedBox(height: Dimensions.height2),
        MediumText(
          color: cColor.grey400,
          size: 12,
          text: TimeTransfer.timeTrans06(
            announce.datePublished,
          ),
        ),
      ],
    );
  }

  Widget _buildLikeSection(AnnounceModel announce, bool isLike) {
    return Row(
      children: [
        Icon(
          isLike ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          color: isLike ? cColor.primary : cColor.grey400,
          size: 20,
        ),
        SizedBox(width: Dimensions.width2),
        MediumText(
          color: cColor.grey400,
          size: 14,
          text: announce.likes.length.toString(),
        ),
      ],
    );
  }

  void _toggleLike(AnnounceModel announce, UserModel? user) async {
    if (user == null) {
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
      bool isLike = announce.likes.contains(user.uuid);
      FirestoreMethods().likeAnnouncement(announce: announce, uid: user.uuid);
      setState(() {
        if (isLike) {
          announce.likes.remove(user.uuid);
        } else {
          announce.likes.add(user.uuid);
        }
      });
    }
  }
}
