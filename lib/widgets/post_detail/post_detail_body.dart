import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upoint/firebase/dynamic_link_service.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/regular_text.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/pages/organizer_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/organizer_fetch_bloc.dart';
import '../../globals/dimension.dart';
import '../../models/organizer_model.dart';

class PostDetailBody extends StatefulWidget {
  final PostModel post;

  const PostDetailBody({super.key, required this.post});

  @override
  State<PostDetailBody> createState() => _PostDetailBodyState();
}

class _PostDetailBodyState extends State<PostDetailBody> {
  late List<Map> informList;
  late CColor cColor;
  final QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    _initializePostContent();
    _initializeInformList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cColor = CColor.of(context);
  }

  void _initializePostContent() {
    _controller.document = Document.fromJson(jsonDecode(widget.post.content!));
  }

  void _initializeInformList() {
    informList = [
      _createInformItem(
          "front",
          Icons.calendar_month,
          TimeTransfer.timeTrans03(
              widget.post.startDateTime, widget.post.endDateTime)),
      _createInformItem(
          "front", Icons.location_on, widget.post.location ?? "無"),
      _createInformItem("front", Icons.local_play, widget.post.reward ?? "無"),
      _createInformItem("back", Icons.home, widget.post.organizerName ?? "無",
          title: "主辦單位：", index: "organizer"),
      _createInformItem("back", Icons.person, widget.post.contact ?? "無",
          title: "聯絡人："),
      _createInformItem("back", Icons.phone, widget.post.phoneNumber ?? "無",
          title: "聯絡方式："),
      _createInformItem("back", Icons.link, "點擊我前往",
          title: "相關連結：", index: "link"),
    ];
  }

  Map<String, dynamic> _createInformItem(
      String type, IconData icon, String text,
      {String? title, String? index}) {
    return {
      "type": type,
      "icon": icon,
      "text": text,
      "title": title,
      "index": index,
    };
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          _buildContentContainer(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandleBar(),
                SizedBox(height: Dimensions.height2 * 4),
                _buildTitleRow(context),
                const SizedBox(height: 5),
                if (widget.post.tags != null) _buildTags(),
                const SizedBox(height: 5),
                Divider(color: cColor.div),
                _buildFrontInformation(),
                _buildIntroductionSection(),
                const SizedBox(height: 18),
                _buildSectionTitle("主辦資訊"),
                Divider(color: cColor.div),
                _buildBackInformation(),
                const SizedBox(height: 18),
                _buildSectionTitle("活動詳情"),
                Divider(color: cColor.div),
                _buildDetailSection(isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentContainer(BuildContext context, {required Widget child}) {
    return Container(
      width: Dimensions.screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width2 * 7.5,
        vertical: Dimensions.height2 * 5,
      ),
      decoration: BoxDecoration(
        color: cColor.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: child,
    );
  }

  Widget _buildHandleBar() {
    return Center(
      child: Container(
        width: Dimensions.width5 * 10,
        height: Dimensions.height2 * 4,
        decoration: BoxDecoration(
          color: cColor.grey200,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: MediumText(
            color: cColor.grey500,
            size: 22,
            text: widget.post.title!,
            maxLines: 10,
          ),
        ),
        CupertinoButton(
          minSize: 0,
          padding: EdgeInsets.only(top: Dimensions.height2),
          onPressed: () async {
            String postLink =
                await DynamicLinkService().createDynamicLink(widget.post);
            try {
              await Share.share(postLink);
            } catch (e) {
              print(e.toString());
            }
          },
          child: _buildShareButton(),
        ),
      ],
    );
  }

  Widget _buildShareButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height2 * 2,
        horizontal: Dimensions.width2 * 3,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: cColor.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.share, color: cColor.primary, size: 16),
          SizedBox(width: Dimensions.width2 * 2),
          MediumText(color: cColor.primary, size: 13, text: '分享 '),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      runSpacing: Dimensions.height2 * 3,
      spacing: Dimensions.width2 * 6,
      children: [
        for (var tag in widget.post.tags!) _tagWidget(tag),
      ],
    );
  }

  Widget _buildFrontInformation() {
    return Column(
      children: [
        for (var inform
            in informList.where((e) => e["type"] == "front").toList())
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    inform["icon"],
                    size: Dimensions.height2 * 12,
                    color: cColor.grey400,
                  ),
                  SizedBox(width: Dimensions.width5 * 2),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "NotoSansMedium",
                          color: cColor.grey500,
                        ),
                        children: [TextSpan(text: inform["text"])],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height5 * 2),
            ],
          ),
      ],
    );
  }

  Widget _buildIntroductionSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height2 * 4,
        horizontal: Dimensions.width2 * 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: cColor.grey200),
      ),
      child: RegularText(
        color: cColor.grey500,
        size: 14,
        text: widget.post.introduction!,
        maxLines: 20,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width2 * 3.2,
        vertical: Dimensions.height2 * 3.2,
      ),
      child: MediumText(color: cColor.grey500, size: 16, text: title),
    );
  }

  Widget _buildBackInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var inform
            in informList.where((e) => e["type"] == "back").toList())
          if (!(inform["index"] == "link" && widget.post.link == null))
            _buildBackInformationRow(inform),
      ],
    );
  }

  Widget _buildBackInformationRow(Map inform) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              inform["icon"],
              size: Dimensions.height2 * 12,
              color: cColor.grey400,
            ),
            SizedBox(width: Dimensions.width5 * 2),
            Flexible(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "NotoSansMedium",
                    color: cColor.grey500,
                  ),
                  children: [
                    if (inform["title"] != null)
                      TextSpan(text: inform["title"]),
                    _buildLinkTextSpan(inform),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height5 * 2),
      ],
    );
  }

  TextSpan _buildLinkTextSpan(Map inform) {
    return TextSpan(
      text: inform["text"],
      style: TextStyle(
        fontFamily:
            inform["index"] == "organizer" ? "NotoSansBold" : "NotoSansMedium",
        color: inform["index"] == "link" ? cColor.primary : cColor.grey500,
        decoration:
            (inform["index"] == "link" || inform["index"] == "organizer")
                ? TextDecoration.underline
                : null,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          if (inform["index"] == "link") {
            launchUrl(Uri.parse(widget.post.link!));
          }
          if (inform["index"] == "organizer") {
            _navigateToOrganizerProfile();
          }
        },
    );
  }

  void _navigateToOrganizerProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          List<OrganizerModel> organizerList =
              Provider.of<OrganzierFetchBloc>(context, listen: false)
                  .organizerList;
          return OrganizerProfile(
            organizer: organizerList.firstWhere(
              (e) => e.uid == widget.post.organizerUid,
            ),
            hero: "post_detail${widget.post.organizerUid}",
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(bool isDarkMode) {
    TextStyle? _sty = isDarkMode ? TextStyle(color: cColor.grey500) : null;

    DefaultTextBlockStyle? defaultTextBlockStyle = isDarkMode
        ? DefaultTextBlockStyle(
            TextStyle(color: cColor.grey500),
            const VerticalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            const BoxDecoration(),
          )
        : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height2 * 4,
        horizontal: Dimensions.width2 * 4,
      ),
      decoration: BoxDecoration(
        color: cColor.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: cColor.grey200),
      ),
      child: QuillEditor.basic(
        configurations: QuillEditorConfigurations(
          customStyles: DefaultStyles(
            h1: defaultTextBlockStyle,
            h2: defaultTextBlockStyle,
            h3: defaultTextBlockStyle,
            h4: defaultTextBlockStyle,
            h5: defaultTextBlockStyle,
            h6: defaultTextBlockStyle,
            paragraph: defaultTextBlockStyle,
            sizeSmall: _sty,
            bold: _sty,
            subscript: _sty,
            superscript: _sty,
            italic: _sty,
            small: _sty,
            underline: _sty,
            strikeThrough: _sty,
            link: TextStyle(
              color: cColor.primary,
              decoration: TextDecoration.underline,
              decorationColor: cColor.primary,
            ),
          ),
          controller: _controller,
          readOnly: true,
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('en'),
          ),
        ),
      ),
    );
  }

  Widget _tagWidget(String tag) {
    return Container(
      height: Dimensions.height2 * 14.5,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width2 * 6,
        vertical: Dimensions.height2 * 3,
      ),
      decoration: BoxDecoration(
        color: cColor.grey100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Text(
              "#",
              style: TextStyle(
                  color: cColor.primary,
                  fontSize: Dimensions.height2 * 7,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: Dimensions.width2 * 2),
            MediumText(
              color: Theme.of(context).colorScheme.onSecondary,
              size: Dimensions.height2 * 6,
              text: tag,
            ),
          ],
        ),
      ),
    );
  }
}
