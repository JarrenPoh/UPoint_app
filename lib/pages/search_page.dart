import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/home_page_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/globals/user_simple_preference.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/widgets/home/post_card.dart';
import 'package:upoint/widgets/search/search_widget.dart';

class SearchPage extends StatefulWidget {
  final HomePageBloc bloc;
  final User? user;
  const SearchPage({
    super.key,
    required this.bloc,
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
    List<PostModel> postList = [];
    widget.bloc.originList.value.forEach((e) {
      postList.add(
        PostModel.fromSnap(e),
      );
    });
    if (query.runes.every(
            (rune) => (rune >= 0x4e00 && rune <= 0x9fff) || rune == 0x3002) ||
        query == '') {
      if (query != '') {
        return debounce(() async {
          List<PostModel> book = postList.where((e) {
            if (e.title!.contains(query) ||
                e.organizer!.contains(query) ||
                e.reward!.contains(query) ||
                e.content!.contains(query)) {
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
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragDown: (details) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: appBarColor,
        appBar: AppBar(
          elevation: 0,
          title: SearchWidget(
            text: query,
            hintText: '輸入想搜尋的內容或標題',
            onChanged: searchBook,
            autoFocus: true,
            controller: controller,
            setState: () => setState(() {
              history = UserSimplePreference.getSearchPostHistory() ?? [];
            }),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: Dimensions.height5 * 2),
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
                          size: 16,
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
                                size: 16,
                                text: "搜尋你想找的東西～",
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                isSearch
                    ? ListView.builder(
                        itemCount: books.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          PostModel model = books[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width5 * 2,
                            ),
                            child: PostCard(
                              post: model,
                              organizer: null,
                              hero: "search${model.title}",
                              isOrganizer: false,
                              user: widget.user,
                            ),
                          );
                        }),
                      )
                    : ListView.builder(
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
                                      size: 28,
                                    ),
                                    title: MediumText(
                                      color: onSecondary,
                                      size: 16,
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
                                ),
                              ],
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
