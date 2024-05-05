import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/user_simple_preference.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/post_card.dart';
import 'package:upoint/widgets/search/search_widget.dart';

class SearchPage extends StatefulWidget {
  final List<PostModel> allPost;
  final UserModel? user;
  const SearchPage({
    super.key,
    required this.allPost,
    required this.user,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  Timer? debouncer;
  String query = '';
  List<PostModel> books = [];
  List<String> history = [];
  bool isSearch = false;
  final controller = TextEditingController();
  void debounce(VoidCallback callback,
      {Duration duration = const Duration(microseconds: 500)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  void initState() {
    super.initState();
    controller.text = query;
    controller.addListener(() {
      if (controller.text.trim() == '') {
        setState(() {
          query = '';
          isSearch = false;
        });
      } else {
        setState(() {
          query = controller.text.trim();
        });
      }
    });
    history = UserSimplePreference.getSearchPostHistory() ?? [];
  }

  void searchBook(String query) {
    List<PostModel> postList = widget.allPost;

    if (query != '') {
      return debounce(() async {
        List<PostModel> book = postList.where((e) {
          if (e.title!.contains(query) ||
              e.organizerName!.contains(query) ||
              (e.reward?.contains(query) ?? false) ||
              e.content!.contains(query) ||
              (e.tags?.any((e) => e.contains(query)) ?? false) ||
              (e.location?.contains(query) ?? false)) {
            return true;
          }
          return false;
        }).toList();

        setState(() {
          isSearch = true;
          this.query = query;
          this.books = book;
        });
      });
    }
  }

  void clear(i) {
    UserSimplePreference.removeSearchPostHistory(i);
    setState(() {
      history = UserSimplePreference.getSearchPostHistory() ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    CColor cColor = CColor.of(context);
    Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: cColor.div,
      appBar: AppBar(
        elevation: 0,
        title: SearchWidget(
          text: query,
          hintText: '輸入任何想搜尋的內容',
          onChanged: searchBook,
          autoFocus: false,
          controller: controller,
          setState: () => setState(() {
            history = UserSimplePreference.getSearchPostHistory() ?? [];
          }),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragDown: (details) {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height5 * 2,
              horizontal: Dimensions.width5 * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                history.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width5 * 2,
                          vertical: Dimensions.height5,
                        ),
                        child: MediumText(
                          color: onSecondary,
                          size: Dimensions.height2 * 8,
                          text: isSearch ? "搜尋結果：" : "曾經搜尋：",
                        ),
                      )
                    : Container(),
                history.isEmpty && !isSearch
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: Dimensions.height5 * 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MediumText(
                                color: onSecondary,
                                size: Dimensions.height2 * 8,
                                text: "搜尋你想找的東西～",
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                isSearch
                    ? GridView.builder(
                        itemCount: books.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Dimensions.height2 * 4,
                          childAspectRatio: 172 / 210,
                          crossAxisSpacing: Dimensions.width2 * 4,
                        ),
                        itemBuilder: (context, index) {
                          PostModel model = books[index];
                          return PostCard(
                            post: model,
                            organizer: null,
                            hero: "search${model.title}",
                            isOrganizer: false,
                            user: widget.user,
                          );
                        },
                      )
                    : Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width5 * 2),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          query = history[index];
                                          controller.text = query;
                                        });
                                        searchBook(history[index]);
                                      },
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.history,
                                          color: primary,
                                          size: Dimensions.height2 * 12,
                                        ),
                                        title: MediumText(
                                          color: onSecondary,
                                          size: Dimensions.height2 * 7,
                                          text: history[index],
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () => clear(index),
                                          child: Container(
                                            width: Dimensions.width5 * 8,
                                            height: Dimensions.height5 * 8,
                                            child: Icon(
                                              CupertinoIcons.clear_circled,
                                              color: primary,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: Dimensions.height5,
                                      color: CColor.of(context).div,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Container(
                            height: 500,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
