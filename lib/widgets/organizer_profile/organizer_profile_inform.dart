import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';

import '../../globals/medium_text.dart';
import '../../globals/scroll_things_provider.dart';
import '../../models/organizer_model.dart';

class OrganizerProfileInform extends StatefulWidget {
  final OrganizerModel organizer;
  final int index;
  const OrganizerProfileInform({
    super.key,
    required this.organizer,
    required this.index,
  });

  @override
  State<OrganizerProfileInform> createState() => _OrganizerProfileInformState();
}

class _OrganizerProfileInformState extends State<OrganizerProfileInform>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  late CColor cColor = CColor.of(context);
  late List<Map> informList = [
    {
      "index": "location",
      "title": "社課地點",
      "text": "活動中心 404",
      "icon": Icons.location_on,
    },
    {
      "index": "duration",
      "title": "社課時間",
      "text": "每週五 17:00~18:00",
      "icon": Icons.access_time,
    },
    {
      "index": "email",
      "title": "Email",
      "text": widget.organizer.email,
      "icon": Icons.email,
    },
    {
      "index": "contact",
      "title": "聯絡電話",
      "text": widget.organizer.phoneNumber,
      "icon": Icons.phone,
    },
    {
      "index": "link",
      "title": "相關連結",
      "text": "活動中心 404",
      "icon": Icons.link,
    },
  ];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller:
          CustomScrollProviderData.of(context).scrollControllers[widget.index],
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width2 * 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimensions.height2 * 4),
                // 單位資料
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height2 * 4,
                    horizontal: Dimensions.width2 * 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 單位資料-標題
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height2 * 2),
                        child: Row(
                          children: [
                            Container(
                              width: Dimensions.width2 * 2,
                              height: 14,
                              color: cColor.primary,
                            ),
                            SizedBox(width: Dimensions.width2 * 4),
                            MediumText(
                              color: cColor.grey500,
                              size: 14,
                              text: "單位資料",
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      // 單位資料-內容
                      for (var inform in informList)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height2 * 2),
                          child: Row(
                            children: [
                              Icon(
                                inform["icon"],
                                size: Dimensions.height2 * 10,
                                color: cColor.grey400,
                              ),
                              SizedBox(width: Dimensions.width2 * 4),
                              MediumText(
                                color: cColor.grey500,
                                size: 13,
                                text: inform["text"] ?? "無",
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height2 * 4),
                // 簡介
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height2 * 4,
                    horizontal: Dimensions.width2 * 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 簡介-標題
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height2 * 2),
                        child: Row(
                          children: [
                            Container(
                              width: Dimensions.width2 * 2,
                              height: 14,
                              color: cColor.primary,
                            ),
                            SizedBox(width: Dimensions.width2 * 4),
                            MediumText(
                              color: cColor.grey500,
                              size: 14,
                              text: "簡介",
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      // 簡介-內容
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height2 * 2),
                        child: MediumText(
                          color: cColor.grey500,
                          size: 13,
                          maxLines: 20,
                          text: widget.organizer.bio,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height2 * 4),
                // 社課內容
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height2 * 4,
                    horizontal: Dimensions.width2 * 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 社課內容-標題
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height2 * 2),
                        child: Row(
                          children: [
                            Container(
                              width: Dimensions.width2 * 2,
                              height: 14,
                              color: cColor.primary,
                            ),
                            SizedBox(width: Dimensions.width2 * 4),
                            MediumText(
                              color: cColor.grey500,
                              size: 14,
                              text: "社課內容",
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      // 社課內容-內容
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height2 * 2),
                        child: MediumText(
                          color: cColor.grey500,
                          size: 13,
                          maxLines: 20,
                          text:
                              "中原大學秉持「全人教育」及「生命關懷」理念，以「服務學習」之實作教育，結合系所專業，具體實踐「生命成長、專業服務、知識責任及社會貢獻」等四大標的，因此於2007年3月設置「服務學習中心」，透過有系統、持續地推動「服務學習」課程與專案，讓中原教職員工生可以透過專業發揮創意，針對「服務」工作，提出解決方案，並透過「從做中學」、「身體力行」，來充分體會如何以專業技能來關懷社會，具體實踐中原大學「全人教育」、以「愛」立校的精神。",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height2 * 4),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
