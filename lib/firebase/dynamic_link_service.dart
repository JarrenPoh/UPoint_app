import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:upoint/models/post_model.dart';

import '../globals/global.dart';

class DynamicLinkService {
  // static final DynamicLinkService _singleton = DynamicLinkService()

  Future<String> createDynamicLink(PostModel post) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://links.upoint.tw/post?postId=${post.postId}"),
      uriPrefix: "https://links.upoint.tw/post",
      androidParameters: AndroidParameters(
        packageName: "com.upoint.android",
        fallbackUrl: Uri.parse(googlePlayLink),
      ),
      iosParameters:  IOSParameters(
        bundleId: "com.upoint.ios",
        appStoreId: "6477217914",
        fallbackUrl: Uri.parse(appleStoreLink),
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: post.title,
        description: post.introduction,
        imageUrl: Uri.parse(post.photo!),
      ),
    );
    ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl.toString();
  }
}
