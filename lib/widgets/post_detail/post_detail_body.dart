import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
        "text": widget.post.link ?? "無",
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
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width2 * 7.5,
              vertical: Dimensions.height2 * 7,
            ),
            color: cColor.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 大標題
                MediumText(
                  color: cColor.grey500,
                  size: Dimensions.height2 * 12,
                  text: widget.post.title!,
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
                Container(
                  height: Dimensions.height2 * 44,
                  margin: EdgeInsets.symmetric(
                    vertical: Dimensions.height2 * 6,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var inform in informList
                          .where((e) => e["type"] == "front")
                          .toList())
                        Row(
                          children: [
                            Icon(
                              inform["icon"],
                              size: Dimensions.height2 * 12,
                              color: cColor.grey400,
                            ),
                            SizedBox(width: Dimensions.width2 * 4),
                            RegularText(
                              color: cColor.grey500,
                              size: Dimensions.height2 * 7,
                              text: inform["text"],
                            ),
                          ],
                        ),
                    ],
                  ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: MediumText(
                    color: cColor.grey500,
                    size: Dimensions.height2 * 8,
                    text: "主辦資訊",
                  ),
                ),
                Divider(color: cColor.div),
                // 主辦資訊內容
                SizedBox(
                  height: Dimensions.height5 * 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var inform in informList
                          .where((e) => e["type"] == "back")
                          .toList())
                        inform["index"] == "link" && widget.post.link == null
                            ? Container()
                            : Row(
                                children: [
                                  Icon(
                                    inform["icon"],
                                    size: Dimensions.height2 * 12,
                                    color: cColor.grey400,
                                  ),
                                  const SizedBox(width: 6),
                                  RegularText(
                                    color: cColor.grey500,
                                    size: Dimensions.height2 * 7,
                                    text: inform["title"],
                                  ),
                                  inform["index"] == "link"
                                      ? GestureDetector(
                                          onTap: () => launchUrl(
                                            Uri.parse(inform["text"]),
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
                                          text: inform["text"],
                                        ),
                                ],
                              ),
                    ],
                  ),
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
                    size: Dimensions.height2 * 8,
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
