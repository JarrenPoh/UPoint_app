import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/bloc/activity_detail_page_bloc.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/overscroll_pop-main/lib/overscroll_pop.dart';
import '../globals/colors.dart';
import '../widgets/activity_detail/act_detail_appbar.dart';
import '../widgets/activity_detail/act_detail_body.dart';
import '../widgets/activity_detail/act_detail_bottom.dart';

class ActivityDetailPage extends StatefulWidget {
  final PostModel post;
  final String hero;
  final UserModel? user;
  const ActivityDetailPage({
    super.key,
    required this.post,
    required this.hero,
    required this.user,
  });

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  late CColor cColor;
  final ActivityDetailPageBloc _bloc = ActivityDetailPageBloc();

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
                  ActDetailAppBar(
                    hero: widget.hero,
                    post: widget.post,
                  ),
                  ActDetailBody(
                    post: widget.post,
                  ),
                ],
              ),
              bottomNavigationBar: ActDetailBottomBar(
                post: widget.post,
                bloc: _bloc,
                user: widget.user,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
