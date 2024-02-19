import 'package:flutter/material.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:upoint/pages/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../bloc/uri_bloc.dart';
import '../pages/sign_form_page.dart';

class ActivityDetailPageBloc {
  onTap(
    bool _isSign,
    BuildContext context,
    PostModel post,
    UserModel? user,
  ) async {
    // CColor cColor = CColor.of(context);
    if (_isSign) {
      // 需要報名，先判斷外部還內部
      if (post.form?.substring(0, 4) == "http") {
        print("前進外部報名");
        final String url = post.form!;
        if (await canLaunch(url)) {
          await launch(url);
        }
      } else {
        if (user == null) {
          String res = await Messenger.dialog(
            '請先登入',
            '您尚未登入帳戶',
            context,
          );
          if (res == "success") {
            // ignore: use_build_context_synchronously
            Provider.of<UriBloc>(context, listen: false).setUri(
              Uri(
                pathSegments: ['activity'],
                queryParameters: {"id": post.postId!},
              ),
            );
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (Route<dynamic> route) => false, // 不保留任何旧路由
            );
          }
        } else {
          print("前進本地報名");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SignFormPage(
                  post: post,
                  user: user,
                );
              },
            ),
          );
        }
      }
    } else {
      if (post.link != null) {
        final String url = post.link!;
        if (await canLaunch(url)) {
          await launch(url);
        }
      }
    }
  }
}
