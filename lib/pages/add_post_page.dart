import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/organizer_model.dart';
import 'package:upoint/global_key.dart' as globals;
import 'package:upoint/widgets/add_post/add_information.dart';
import 'package:upoint/widgets/add_post/add_other.dart';
import 'package:upoint/widgets/add_post/add_picture.dart';
import 'package:upoint/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  final Function() backToHome;
  final OrganModel? organizer;
  final bool isEdit;
  final AddPostPageBloc bloc;

  AddPostPage({
    super.key,
    required this.backToHome,
    required this.organizer,
    required this.isEdit,
    required this.bloc,
  });

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  @override
  final bool wantKeepAlive = true;
  var currPageValue = 0;
  @override
  void initState() {
    super.initState();
    widget.bloc.pageWidget = [
      AddPicture(
        bloc: widget.bloc,
        isEdit: widget.isEdit,
      ),
      AddInformation(
        bloc: widget.bloc,
        organizer: widget.organizer,
        isEdit: widget.isEdit,
      ),
      AddOther(
        bloc: widget.bloc,
        isEdit: widget.isEdit,
      ),
    ];
    widget.bloc.itemCount = widget.bloc.pageWidget.length;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color primary = Theme.of(context).colorScheme.primary;
    Color hintColor = Theme.of(context).hintColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: onSecondary),
        automaticallyImplyLeading: widget.isEdit ? true : false,
        title: Padding(
          padding: EdgeInsets.only(bottom: Dimensions.height5 * 5),
          child: BoldText(
            color: onSecondary,
            size: 16,
            text: "發佈活動",
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width5 * 2,
          vertical: Dimensions.height5 * 2,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: widget.bloc.pageController,
                    itemCount: widget.bloc.itemCount,
                    itemBuilder: (context, index) {
                      return widget.bloc.pageWidget[index];
                    },
                    onPageChanged: (value) {
                      setState(() {
                        currPageValue = value;
                      });
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.height5 * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Dimensions.width5 * 17,
                        child: CupertinoButton(
                          onPressed: () {
                            currPageValue == 0
                                ? null
                                : widget.bloc.pageController
                                    .jumpToPage(currPageValue - 1);
                            FocusScope.of(context).unfocus();
                          },
                          child: Text(
                            currPageValue == 0 ? '' : 'Back',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimensions.height5 * 3.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.width5 * 17,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height2 * 2),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.circular(Dimensions.height5),
                          ),
                          child: MediumText(
                            color: onSecondary,
                            size: Dimensions.height5 * 3,
                            text:
                                '已完成${currPageValue + 1}/${widget.bloc.itemCount}',
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: currPageValue + 1 == 1
                            ? widget.bloc.addPictureNotifier
                            : currPageValue + 1 == 2
                                ? widget.bloc.addInformNotifier
                                : widget.bloc.addOtherNotifier,
                        builder: (context, value, child) {
                          value as bool;
                          return SizedBox(
                            width: Dimensions.width5 * 17,
                            child: CupertinoButton(
                              onPressed: () async {
                                if (currPageValue + 1 != 3) {
                                  if (value) {
                                    widget.bloc.pageController
                                        .jumpToPage(currPageValue + 1);
                                  }
                                  if (!value) {
                                    CustomDialog(
                                      context,
                                      '',
                                      currPageValue + 1 == 1
                                          ? '請至少選取一張照片'
                                          : '請完成所有必填項目',
                                      onSecondary,
                                      onSecondary,
                                      () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  }
                                  FocusScope.of(context).unfocus();
                                } else {
                                  FocusScope.of(context).unfocus();
                                  await CustomDialog(
                                    context,
                                    '',
                                    '注意！請確認填寫無誤',
                                    onSecondary,
                                    onSecondary,
                                    () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (widget.isEdit) {
                                        await widget.bloc.updatePost(
                                          context,
                                          widget.organizer,
                                          Provider.of<AddPostPageBloc>(context,
                                                  listen: false)
                                              .cart,
                                        );
                                      } else {
                                        await widget.bloc.uploadPost(
                                          context,
                                          widget.organizer,
                                          Provider.of<AddPostPageBloc>(context,
                                                  listen: false)
                                              .cart,
                                        );
                                      }
                                      // unFisnished: 導到活動頁面
                                      widget.backToHome();
                                      globals
                                          .globalBottomNavigation!.currentState!
                                          .onGlobalTap(0);
                                    },
                                  );
                                }
                              },
                              child: Text(
                                currPageValue + 1 == 3 ? 'Finish' : 'Next',
                                style: TextStyle(
                                  color: !value ? primary : hintColor,
                                  fontSize: Dimensions.height5 * 3.5,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            isLoading
                ? Container(
                    height: Dimensions.height5 * 14,
                    width: Dimensions.width5 * 14,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: onPrimary,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
