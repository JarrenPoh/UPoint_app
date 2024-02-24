import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/inbox_page_bloc.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/date_time_transfer.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/regular_text.dart';
import 'package:upoint/models/inbox_model.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/pages/post_detail_page.dart';
import 'package:upoint/pages/login_page.dart';
import 'package:upoint/secret.dart';
import 'package:provider/provider.dart';

class InboxPage extends StatefulWidget {
  final UserModel? user;
  const InboxPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final bloc = Provider.of<InboxPageBloc>(context, listen: false);

  init() {
    if (widget.user != null) {
      bloc.fetchNext(widget.user!.uuid);
    }
  }

  go(url) {
    Uri uri = Uri.parse(url);
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'activity') {
      final parameter = uri.queryParameters['id'];
      findAndGoPost(parameter);
    }
  }

  findAndGoPost(postId) async {
    PostModel _p = await FirestoreMethods().fetchPostById(postId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(
            post: _p,
            hero: "activity${_p.datePublished.toString()}",
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
    super.build(context);
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;

    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: MediumText(
            color: onSecondary,
            size: Dimensions.height2 * 8,
            text: '收件欄',
          ),
        ),
      ),
      body: widget.user == null
          ? loginContainer()
          : RefreshIndicator(
              displacement: 100,
              backgroundColor: onPrimary,
              color: onSecondary,
              onRefresh: () async {
                await bloc.onRefresh();
              },
              child: ListView(
                controller: bloc.scrollController,
                physics: BouncingScrollPhysics(),
                children: [
                  ValueListenableBuilder(
                    valueListenable: bloc.notifierProvider,
                    builder: (context, value, child) {
                      value as Map;
                      bool _noMore = value['bool'];
                      bool _isLoading = value['isLoading'];
                      List<dateGroup> _list = [];
                      _list = value['list'].cast<dateGroup>();
                      return _isLoading
                          //shimmer
                          ? Center(
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: onSecondary,
                              ),
                            )
                          : Column(
                              children: [
                                if (_list.isNotEmpty)
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _list.length,
                                    itemBuilder: (context, lindex) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions.width5,
                                              vertical: Dimensions.height5,
                                            ),
                                            child: MediumText(
                                              color: onSecondary,
                                              size: Dimensions.height2 * 9,
                                              text: _list[lindex].title,
                                            ),
                                          ),
                                          listBuilder(_list, lindex),
                                          Divider(
                                              color: CColor.of(context).div),
                                        ],
                                      );
                                    },
                                  ),
                                if (_list.isEmpty && _noMore == true)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        2 /
                                        3,
                                    child: Center(
                                        child: Text(
                                      'No Result.',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: onSecondary),
                                    )),
                                  ),
                                if (_noMore == false)
                                  CircularProgressIndicator.adaptive(
                                    backgroundColor: onSecondary,
                                  ),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget listBuilder(List<dateGroup> _list, int lindex) {
    CColor cColor = CColor.of(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // controller: controller,
      // physics: BouncingScrollPhysics(),
      itemCount: _list[lindex].inboxModel.length,
      itemBuilder: (context, index) {
        InboxModel inboxModel = _list[lindex].inboxModel[index];
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width5 * 4,
            vertical: Dimensions.height2 * 6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: cColor.grey200,
                    radius: 20,
                    child: CircleAvatar(
                      backgroundColor: cColor.grey200,
                      radius: 18,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          inboxModel.pic ?? defaultUserPic,
                        ),
                        radius: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width5 * 3),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: Dimensions.height2 * 6.5),
                        children: [
                          TextSpan(
                            text: inboxModel.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cColor.grey500,
                            ),
                          ),
                          const TextSpan(
                            text: '   ',
                          ),
                          TextSpan(
                            text: inboxModel.text,
                            style: TextStyle(
                              color: cColor.grey500,
                            ),
                          ),
                          TextSpan(
                            text: '  - ${relativeDateFormat(
                              inboxModel.datePublished.toDate(),
                            )}',
                            style: TextStyle(
                              color: cColor.grey400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width5 * 2),
                  CupertinoButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width5 * 4,
                    ),
                    minSize: Dimensions.height5 * 6,
                    color: cColor.primary,
                    child: MediumText(
                      color: Colors.white,
                      size: Dimensions.height2 * 6,
                      text: '前往',
                    ),
                    onPressed: () => go(inboxModel.url),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget loginContainer() {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.width5 * 10),
          decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                offset: Offset(2, 2),
                blurRadius: 3,
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RegularText(
                            color: onSecondary,
                            size: Dimensions.height2 * 7,
                            text: "歡迎登入，查看更多資訊",
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: MediumText(
                            color: onSecondary,
                            size: Dimensions.height2 * 8,
                            text: "登入",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
