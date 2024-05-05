import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:share_plus/share_plus.dart';
import 'package:upoint/firebase/dynamic_link_service.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/regular_text.dart';
import 'package:upoint/models/post_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../globals/dimension.dart';

class PostDetailBody extends StatefulWidget {
  final PostModel post;
  const PostDetailBody({
    super.key,
    required this.post,
  });

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
    initList();
    _controller.document = Document.fromJson(jsonDecode(widget.post.content!));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cColor = CColor.of(context);
    debugPrint(widget.post.content!);
  }

  initList() {
    informList = [
      {
        "type": "front",
        "icon": Icons.calendar_month,
        "text": TimeTransfer.timeTrans03(
          widget.post.startDateTime,
          widget.post.endDateTime,
        ),
      },
      {
        "type": "front",
        "icon": Icons.location_on,
        "text": widget.post.location,
      },
      {
        "type": "front",
        "icon": Icons.local_play,
        "text": widget.post.reward ?? "無",
      },
      {
        "title": "主辦單位：",
        "type": "back",
        "icon": Icons.home,
        "text": widget.post.organizerName,
      },
      {
        "title": "聯絡人：",
        "type": "back",
        "icon": Icons.person,
        "text": widget.post.contact ?? "無",
      },
      {
        "title": "聯絡方式：",
        "type": "back",
        "icon": Icons.phone,
        "text": widget.post.phoneNumber ?? "無",
      },
      {
        "title": "相關連結：",
        "type": "back",
        "icon": Icons.link,
        "text": "點擊我前往",
        "index": "link"
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    TextStyle? _sty = isDarkMode
        ? TextStyle(
            color: cColor.grey500,
          )
        : null;
    DefaultTextBlockStyle? defaultTextBlockStyle = isDarkMode
        ? DefaultTextBlockStyle(
            TextStyle(
              color: cColor.grey500,
            ),
            const VerticalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            const BoxDecoration(),
          )
        : null;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: Dimensions.width5 * 10,
                    height: Dimensions.height2 * 4,
                    decoration: BoxDecoration(
                      color: cColor.grey200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height2 * 4),
                // 大標題
                Row(
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
                        String postLink = await DynamicLinkService()
                            .createDynamicLink(widget.post);
                        try {
                          await Share.share(postLink);
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Container(
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
                            Icon(
                              Icons.share,
                              color: cColor.primary,
                              size: 16,
                            ),
                            SizedBox(width: Dimensions.width2 * 2),
                            MediumText(
                              color: cColor.primary,
                              size: 13,
                              text: '分享 ',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // 活動標籤
                if (widget.post.tags != null)
                  Wrap(
                    runSpacing: Dimensions.height2 * 3,
                    spacing: Dimensions.width2 * 6,
                    children: [
                      for (var i in widget.post.tags!) _tagWidget(i),
                    ],
                  ),
                const SizedBox(height: 5),
                Divider(color: cColor.div),
                // 時間 地點 獎勵
                Column(
                  children: [
                    for (var inform in informList
                        .where((e) => e["type"] == "front")
                        .toList())
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                inform["icon"],
                                size: Dimensions.height2 * 12,
                                color: cColor.grey400,
                              ),
                              SizedBox(width: Dimensions.width5 * 2),
                              Wrap(
                                children: [
                                  MediumText(
                                    color: cColor.grey500,
                                    size: 14,
                                    text: inform["text"],
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.height5 * 2),
                        ],
                      ),
                  ],
                ),
                // 介紹內容
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height2 * 4,
                    horizontal: Dimensions.width2 * 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: cColor.div),
                  ),
                  child: RegularText(
                    color: cColor.grey500,
                    size: Dimensions.height2 * 7,
                    text: widget.post.introduction!,
                    maxLines: 20,
                  ),
                ),
                const SizedBox(height: 18),
                // 主辦資訊
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width2 * 3.2,
                    vertical: Dimensions.height2 * 3.2,
                  ),
                  child: MediumText(
                    color: cColor.grey500,
                    size: 16,
                    text: "主辦資訊",
                  ),
                ),
                Divider(color: cColor.div),
                // 主辦資訊內容
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var inform in informList
                        .where((e) => e["type"] == "back")
                        .toList())
                      inform["index"] == "link" && widget.post.link == null
                          ? Container()
                          : Column(
                              children: [
                                Wrap(
                                  children: [
                                    Icon(
                                      inform["icon"],
                                      size: Dimensions.height2 * 12,
                                      color: cColor.grey400,
                                    ),
                                    SizedBox(width: Dimensions.width5 * 2),
                                    MediumText(
                                      color: cColor.grey500,
                                      size: 14,
                                      text: inform["title"],
                                    ),
                                    inform["index"] == "link"
                                        ? GestureDetector(
                                            onTap: () => launchUrl(
                                              Uri.parse(widget.post.link!),
                                            ),
                                            child: RegularText(
                                              color: cColor.primary,
                                              size: Dimensions.height2 * 7,
                                              text: inform["text"],
                                            ),
                                          )
                                        : RegularText(
                                            color: cColor.grey500,
                                            size: Dimensions.height2 * 7,
                                            maxLines: 2,
                                            text: inform["text"],
                                          ),
                                  ],
                                ),
                                SizedBox(height: Dimensions.height5 * 2),
                              ],
                            ),
                  ],
                ),
                const SizedBox(height: 18),
                // 活動詳情標題
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width2 * 3.2,
                    vertical: Dimensions.height2 * 3.2,
                  ),
                  height: Dimensions.height2 * 18,
                  child: MediumText(
                    color: cColor.grey500,
                    size: 16,
                    text: "活動詳情",
                  ),
                ),
                Divider(color: cColor.div),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height2 * 4,
                    horizontal: Dimensions.width2 * 4,
                  ),
                  decoration: BoxDecoration(
                    color: cColor.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: cColor.div),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagWidget(String tag) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
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
              color: onSecondary,
              size: Dimensions.height2 * 6,
              text: tag,
            ),
          ],
        ),
      ),
    );
  }
}
