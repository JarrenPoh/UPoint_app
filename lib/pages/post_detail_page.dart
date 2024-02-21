import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/post_detail_page_bloc.dart';
import 'package:upoint/firebase/auth_methods.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/overscroll_pop-main/lib/overscroll_pop.dart';
import 'package:upoint/widgets/post_detail/post_detail_appbar.dart';
import 'package:upoint/widgets/post_detail/post_detail_body.dart';
import '../globals/colors.dart';
import 'package:provider/provider.dart';

import '../widgets/post_detail/post_detail_bottom.dart';

class PostDetailPage extends StatefulWidget {
  final PostModel post;
  final String hero;
  const PostDetailPage({
    super.key,
    required this.post,
    required this.hero,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late CColor cColor;
  final PostDetailPageBloc _bloc = PostDetailPageBloc();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cColor = CColor.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return OverscrollPop(
      scrollToPopOption: ScrollToPopOption.start,
      dragToPopDirection: DragToPopDirection.horizontal,
      child: Scaffold(
        body: Container(
          color: cColor.white,
          child: SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: Scaffold(
              backgroundColor: cColor.white,
              body: CustomScrollView(
                slivers: [
                  // APP BAR
                  PostDetailAppBar(
                    hero: widget.hero,
                    post: widget.post,
                  ),
                  PostDetailBody(
                    post: widget.post,
                  ),
                ],
              ),
              bottomNavigationBar: Consumer<AuthMethods>(
                  builder: (context, userNotifier, child) {
                UserModel? user = userNotifier.user;
                return PostDetailBottomBar(
                  post: widget.post,
                  bloc: _bloc,
                  user: user,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
