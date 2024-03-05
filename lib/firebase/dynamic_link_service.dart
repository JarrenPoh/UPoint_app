import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  // static final DynamicLinkService _singleton = DynamicLinkService()

  void createDynamicLink() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://links.upoint.tw/"),
      uriPrefix: "https://links.upoint.tw",
      androidParameters:
          const AndroidParameters(packageName: "com.upoint.android"),
      iosParameters: const IOSParameters(bundleId: "com.upoint.ios"),
    );
    ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  }
}
