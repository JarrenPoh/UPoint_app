import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/regular_text.dart';
import 'package:upoint/models/post_model.dart';

import '../../globals/dimension.dart';

class ActDetailBody extends StatefulWidget {
  final PostModel post;
  const ActDetailBody({
    super.key,
    required this.post,
  });

  @override
  State<ActDetailBody> createState() => _ActDetailBodyState();
}

class _ActDetailBodyState extends State<ActDetailBody> {
  late List<Map> informList;
  late CColor cColor;
  // final QuillController _controller = QuillController.basic();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cColor = CColor.of(context);
    print(widget.post.content!);
    // _controller.document = Document.fromJson(jsonDecode(widget.post.content!));
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
        "text": widget.post.reward,
      },
      // {
      //   "type": "latter",
      //   "icon": Icons.home_filled,
      //   "text": "主辦單位：",
      // },
      // {
      //   "type":"latter",
      //   "icon":Icons.person,
      //   "text":"聯絡人：",
      // },  {
      //   "type":"latter",
      //   "icon":Icons.phone,
      //   "text":"聯絡電話：",
      // },{
      //   "type":"latter",
      //   "icon":Icons.email,
      //   "text":"Email：",
      // },
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                  size: 24,
                  text: widget.post.title!,
                ),
                const SizedBox(height: 5),
                // 活動標籤
                Wrap(
                  runSpacing: Dimensions.height2 * 3,
                  spacing: Dimensions.width2 * 6,
                  children: [
                    for (var i in widget.post.tags!) _tagWidget(i),
                  ],
                ),
                const SizedBox(height: 5),
                Divider(color: cColor.grey200),
                // 時間 地點 獎勵
                Container(
                  height: Dimensions.height2 * 44,
                  margin: EdgeInsets.symmetric(
                    vertical: Dimensions.height2 * 6,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var inform in informList)
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
                    border: Border.all(color: cColor.grey200),
                  ),
                  child: RegularText(
                    color: cColor.grey500,
                    size: Dimensions.height2 * 7,
                    text: widget.post.introduction!,
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
                Divider(color: cColor.grey200),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     vertical: Dimensions.height2 * 9,
                //   ),
                //   child: QuillEditor.basic(
                //     configurations: QuillEditorConfigurations(
                //       controller: _controller,
                //       readOnly: true,
                //       sharedConfigurations: const QuillSharedConfigurations(
                //         locale: Locale('en'),
                //       ),
                //     ),
                //   ),
                // ),
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
