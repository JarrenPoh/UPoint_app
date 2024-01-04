import 'package:flutter/material.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/post_model.dart';

class SignListPage extends StatefulWidget {
  final PostModel post;
  const SignListPage({
    super.key,
    required this.post,
  });

  @override
  State<SignListPage> createState() => _SignListPageState();
}

class _SignListPageState extends State<SignListPage> {
  late List _list;
  @override
  void initState() {
    super.initState();
    _list = widget.post.signList ?? [];
  }

  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: onSecondary),
        title: MediumText(
          color: onSecondary,
          size:Dimensions.height2 * 8,
          text: '報名名單',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width5 * 2),
          child: Column(
            children: [
              SizedBox(height: Dimensions.height5 * 5),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width5 * 4,
                  vertical: Dimensions.height5 * 2,
                ),
                decoration: BoxDecoration(
                    color: appBarColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryContainer)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediumText(
                      color: onSecondary,
                      size: Dimensions.height2 * 10,
                      text: '${widget.post.title} - 報名名單',
                    ),
                    SizedBox(height: Dimensions.height5 * 2),
                    Divider(
                      color: primaryContainer,
                      thickness: 1,
                    ),
                    SizedBox(height: Dimensions.height5 * 2),
                    Column(
                      children: _list.isEmpty
                          ? [
                              MediumText(
                                color: onSecondary,
                                size: Dimensions.height2 * 8,
                                text: '還沒有人報名此活動！',
                              ),
                            ]
                          : List.generate(
                              _list.length,
                              (index) {
                                return signRow(
                                  _list[index],
                                  index,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signRow(Map map, int i) {
    Color hintColor = Theme.of(context).hintColor;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    List _list = ["信箱", "姓名", "學號", "聯絡電話", "系級"];
    List _m = [
      "email",
      "name",
      "studentID",
      "phoneNumber",
      "className",
      "email"
    ];
    return ExpansionTile(
      tilePadding: EdgeInsets.all(0),
      childrenPadding: EdgeInsets.only(
        bottom: Dimensions.height5 * 2,
      ),
      trailing: Icon(
        Icons.arrow_drop_down_sharp,
        color: hintColor,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width5,
              vertical: Dimensions.height2,
            ),
            child: Text(
              i.toString(),
              style: TextStyle(color: onSecondary),
            ),
          ),
          MediumText(
            color: onSecondary,
            size: Dimensions.height2 * 8,
            text: map['email'],
          ),
          MediumText(
            color: Colors.grey,
            size: Dimensions.height2 * 6.5,
            text: relativeDateFormat(
              map['datePublished'].toDate(),
            ),
          ),
        ],
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            _list.length,
            (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: Dimensions.width5 * 10),
                        MediumText(
                          color: Colors.grey,
                          size: Dimensions.height2 * 7,
                          text: _list[index],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        SizedBox(width: Dimensions.width5 * 4),
                        MediumText(
                          color: onSecondary,
                          size: Dimensions.height2 * 7,
                          text: map[_m[index]],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
