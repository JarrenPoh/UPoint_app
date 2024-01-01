import 'dart:async';

import 'package:flutter/material.dart';
import 'package:upoint/bloc/search_page_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/widgets/home/post_card.dart';
import 'package:upoint/widgets/search/search_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  SearchPageBloc bloc = SearchPageBloc();
  Timer? debouncer;
  String query = '';
  List<PostModel> books = [];
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
    print('---------------initstate---------------');
  }

  void searchBook(String query) {
    if (query.runes.every(
            (rune) => (rune >= 0x4e00 && rune <= 0x9fff) || rune == 0x3002) ||
        query == '') {
      if (query != '') {
        return debounce(() async {
          List<PostModel> book = bloc.postList.where((e) {
            if (e.title!.contains(query) ||
                e.organizer!.contains(query) ||
                e.reward!.contains(query) ||
                e.content!.contains(query)) {
              return true;
            }
            return false;
          }).toList();

          setState(() {
            this.query = query;
            this.books = book;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragDown: (details) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: SearchWidget(
            text: query,
            hintText: '輸入想搜尋的內容或標題',
            onChanged: searchBook,
            autoFocus: true,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: Dimensions.height5 * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width5 * 2,
                  vertical: Dimensions.height5,
                ),
                child: MediumText(
                  color: onSecondary,
                  size: 16,
                  text: "搜尋結果：",
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
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
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
