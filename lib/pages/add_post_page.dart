import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/globals/bold_text.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/widgets/add_post/add_information.dart';
import 'package:upoint/widgets/add_post/add_other.dart';
import 'package:upoint/widgets/add_post/add_picture.dart';
import 'package:upoint/widgets/custom_dialog.dart';

class AddPostPage extends StatefulWidget {
  final Function(int) onIconTapped;

  const AddPostPage({
    super.key,
    required this.onIconTapped,
  });

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  final AddPostPageBloc _bloc = AddPostPageBloc();
  var currPageValue = 0;
  @override
  void initState() {
    super.initState();
    _bloc.pageWidget = [
      AddPicture(bloc: _bloc),
      AddInformation(bloc: _bloc),
      AddOther(bloc: _bloc),
    ];
    _bloc.itemCount = _bloc.pageWidget.length;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color primary = Theme.of(context).colorScheme.primary;
    Color hintColor = Theme.of(context).hintColor;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;

    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _bloc.pageController,
                itemCount: _bloc.itemCount,
                itemBuilder: (context, index) {
                  return _bloc.pageWidget[index];
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
                            : _bloc.pageController
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
                        borderRadius: BorderRadius.circular(Dimensions.height5),
                      ),
                      child: MediumText(
                        color: onSecondary,
                        size: Dimensions.height5 * 3,
                        text: '已完成${currPageValue + 1}/${_bloc.itemCount}',
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: currPageValue + 1 == 1
                        ? _bloc.addPictureNotifier
                        : currPageValue + 1 == 2
                            ? _bloc.addInformNotifier
                            : _bloc.addOtherNotifier,
                    builder: (context, value, child) {
                      value as bool;
                      return SizedBox(
                        width: Dimensions.width5 * 17,
                        child: CupertinoButton(
                          onPressed: () async {
                            if (currPageValue + 1 != 3) {
                              if (value) {
                                _bloc.pageController
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
                              await _bloc.uploadPost(context);
                              widget.onIconTapped(0);
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
      ),
    );
  }
}
