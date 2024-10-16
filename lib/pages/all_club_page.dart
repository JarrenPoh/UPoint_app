import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upoint/bloc/organizer_fetch_bloc.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/widgets/home/club_card.dart';
import '../globals/dimension.dart';
import '../globals/medium_text.dart';
import '../models/organizer_model.dart';

class AllClubPage extends StatefulWidget {
  const AllClubPage({
    super.key,
  });

  @override
  State<AllClubPage> createState() => _AllClubPageState();
}

class _AllClubPageState extends State<AllClubPage> {
  late Color scaffoldBackgroundColor =
      Theme.of(context).scaffoldBackgroundColor;
  late CColor cColor = CColor.of(context);
  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      backgroundColor: Colors.transparent,
      onDismissed: () {
        Navigator.of(context).pop();
      },
      direction: DismissiblePageDismissDirection.horizontal,
      isFullScreen: true,
      child: Scaffold(
        backgroundColor: cColor.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: cColor.grey500, size: 20),
          title: MediumText(
            color: cColor.grey500,
            size: Dimensions.height2 * 8,
            text: '所有社團',
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width5 * 2,
              vertical: Dimensions.height2 * 6,
            ),
            child: Column(
              children: [
                // 社團列表
                Consumer<OrganzierFetchBloc>(
                  builder: (BuildContext context, OrganzierFetchBloc value,
                      Widget? child) {
                    List<OrganizerModel> clubList = List.from(value.organizerList);
                    clubList.removeWhere((element) => element.username == "全部");
                    return clubList.isEmpty
                        ? Column(
                            children: [
                              SizedBox(height: Dimensions.height5 * 16),
                              Center(
                                child: MediumText(
                                  color: cColor.grey500,
                                  size: Dimensions.height2 * 8,
                                  text: "No Result.",
                                ),
                              ),
                              SizedBox(height: Dimensions.height5 * 200),
                            ],
                          )
                        : GridView.custom(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: Dimensions.height2 * 4,
                              childAspectRatio: 172 / 88,
                              crossAxisSpacing: Dimensions.width2 * 4,
                            ),
                            childrenDelegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ClubCard(
                                  hero:
                                      "all_club_page${clubList[index].uid.toString()}",
                                  club: clubList[index],
                                );
                              },
                              childCount: clubList.length, // 10个网格项
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
