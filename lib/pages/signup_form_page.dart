import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/post_model.dart';
import 'package:upoint/models/user_model.dart';
import 'package:get/get.dart';

class SignUpFormPage extends StatefulWidget {
  final PostModel post;
  final User user;
  const SignUpFormPage({
    super.key,
    required this.post,
    required this.user,
  });
  @override
  State<SignUpFormPage> createState() => _SignUpFormPageState();
}

class _SignUpFormPageState extends State<SignUpFormPage> {
  List _list = ["信箱", "姓名", "學號", "聯絡電話", "系級"];
  late List<TextEditingController> controllers;
  late List<bool> emptyInputs;
  @override
  void initState() {
    super.initState();
    controllers =
        List.generate(_list.length, (index) => TextEditingController());
    emptyInputs = List.generate(_list.length, (index) => false);
    for (var i = 0; i < controllers.length; i++) {
      if (emptyInputs[i] == true) {
        controllers[i].addListener(() {
          setState(() {
            controllers[i].text.trim() == ''
                ? emptyInputs[i] = true
                : emptyInputs[i] = false;
          });
        });
      }
    }
    List _inform = [];
    _inform.addAll([
      widget.user.email.endsWith('@privaterelay.appleid.com')
          ? ''
          : widget.user.email,
      widget.user.username ?? '',
      widget.user.studentID ?? '',
      widget.user.phoneNumber ?? '',
      widget.user.className ?? '',
    ]);
    for (var i = 0; i < controllers.length; i++) {
      controllers[i].text = _inform[i] ?? '';
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String check() {
    for (var i = 0; i < controllers.length; i++) {
      if (controllers[i].text.trim() == '') {
        setState(() {
          emptyInputs[i] = true;
        });
        return 'error';
      }
    }
    return 'success';
  }

  Future<String> sent(PostModel post, User user) async {
    DateTime _now = DateTime.now();
    String res = await FirestoreMethods().sentSignForm(
      post.postId!,
      {
        "email": controllers[0].text,
        "name": controllers[1].text,
        "studentID": controllers[2].text,
        "phoneNumber": controllers[3].text,
        "className": controllers[4].text,
        "datePublished": _now,
      },
      user,
      {
        "postId": post.postId!,
        "title": post.title,
        "datePublished": _now,
      },
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color hintColor = Theme.of(context).hintColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: onSecondary),
        title: MediumText(
          color: onSecondary,
          size: 16,
          text: '報名表單',
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width5 * 4),
            child: Column(
              children: [
                SizedBox(height: Dimensions.height5 * 5),
                titleContainer(),
                SizedBox(height: Dimensions.height5 * 7),
                Container(
                  width: Dimensions.screenWidth,
                  height: Dimensions.height5 * 6,
                  decoration: BoxDecoration(
                    color: hintColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                ),
                Column(
                  children: List.generate(
                    _list.length,
                    (index) => Column(
                      children: [
                        inputWidget(
                          _list[index],
                          controllers[index],
                          emptyInputs[index],
                          index,
                        ),
                        SizedBox(height: Dimensions.height5 * 4),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height5 * 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width5 * 4,
                          vertical: Dimensions.height5 * 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MediumText(
                          color: Colors.white,
                          size: 16,
                          text: '取消',
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoButton(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width5 * 4,
                          vertical: Dimensions.height5 * 2,
                        ),
                        decoration: BoxDecoration(
                          color: hintColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MediumText(
                          color: Colors.white,
                          size: 16,
                          text: '送出',
                        ),
                      ),
                      onPressed: () async {
                        String res = check();
                        if (res == 'success') {
                          String result = await sent(widget.post, widget.user);
                          if (result == 'success') {
                            Get.snackbar(
                              "報名成功",
                              "請記得出席",
                              snackPosition: SnackPosition.TOP,
                              duration: const Duration(
                                seconds: 2,
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            Get.snackbar(
                              "報名失敗",
                              result,
                              snackPosition: SnackPosition.TOP,
                              duration: const Duration(
                                seconds: 2,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height5 * 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputWidget(
    String str,
    TextEditingController controller,
    bool emptyInput,
    int index,
  ) {
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color hintColor = Theme.of(context).hintColor;
    Color primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height5 * 5,
      ),
      decoration: BoxDecoration(
        color: appBarColor,
        borderRadius: index == 0
            ? BorderRadius.vertical(bottom: Radius.circular(10))
            : BorderRadius.circular(10),
        border: Border.all(color: primaryContainer),
      ),
      width: Dimensions.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width5 * 5,
            ),
            child: Row(
              children: [
                MediumText(
                  color: onSecondary,
                  size: 15,
                  text: str,
                ),
                MediumText(
                  color: Colors.red,
                  size: 15,
                  text: ' *',
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height5 * 2),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width5 * 5,
            ),
            child: TextField(
              onSubmitted: (null),
              controller: controller,
              style: TextStyle(color: onSecondary),
              cursorColor: hintColor,
              decoration: InputDecoration(
                errorText: emptyInput ? '不可為空' : null,
                hintText: '您的回答',
                hintStyle: TextStyle(color: primary),
                contentPadding: EdgeInsets.symmetric(
                  vertical: Dimensions.height2 * 7,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryContainer),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleContainer() {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height5 * 5,
      ),
      decoration: BoxDecoration(
          color: appBarColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryContainer)),
      width: Dimensions.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width5 * 5,
            ),
            child: MediumText(
              color: onSecondary,
              size: 20,
              text: '${widget.post.organizer} - ${widget.post.title!}',
            ),
          ),
          SizedBox(height: Dimensions.height5 * 2),
          Divider(
            color: primaryContainer,
            thickness: 1,
          ),
          SizedBox(height: Dimensions.height5 * 2),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width5 * 5,
            ),
            child: const MediumText(
              color: Colors.grey,
              size: 15,
              text: '報名完成後，我們將會有通知寄送給您～',
            ),
          ),
          SizedBox(height: Dimensions.height5 * 2),
          Divider(
            color: primaryContainer,
            thickness: 1,
          ),
          SizedBox(height: Dimensions.height5 * 2),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width5 * 5,
            ),
            child: const MediumText(
              color: Colors.red,
              size: 15,
              text: '* 表示必填問題',
            ),
          ),
        ],
      ),
    );
  }
}
