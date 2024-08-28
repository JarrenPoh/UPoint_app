import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:url_launcher/url_launcher.dart';

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
      "index": "actLocation",
      "title": "社課地點",
      "text": widget.organizer.actLocation,
      "icon": Icons.location_on,
    },
    {
      "index": "actTime",
      "title": "社課時間",
      "text": widget.organizer.actTime,
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
      "index": "links",
      "title": "相關連結",
      "links": widget.organizer.links ?? [],
      "icon": Icons.link,
    },
  ];
  List links = [];
  @override
  void initState() {
    super.initState();
  }

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
                              if (inform["index"] != "links")
                                MediumText(
                                  color: cColor.grey500,
                                  size: 13,
                                  text: inform["text"] ?? "無",
                                ),
                              if (inform["index"] == "links")
                                Wrap(
                                  spacing: 5,
                                  runSpacing: 10,
                                  children: [
                                    if (inform["links"].isEmpty ||
                                        inform["links"] == null)
                                      MediumText(
                                        color: cColor.grey500,
                                        size: 13,
                                        text: "無",
                                      ),
                                    for (var i in inform["links"])
                                      SizedBox(
                                        height: Dimensions.height2 * 10,
                                        child: CupertinoButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () async {
                                            if (i["url"] != null) {
                                              final String url = i["url"];
                                              try {
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                }
                                              } catch (e) {
                                                print(e.toString());
                                              }
                                            }
                                          },
                                          child: Text(
                                            i["text"],
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: cColor.primary,
                                              fontFamily: "NotoSansMedium",
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
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
                          text: widget.organizer.actBio ?? "無",
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
