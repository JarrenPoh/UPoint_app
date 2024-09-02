import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/custom_messengers.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/user_model.dart';
import '../bloc/sign_form_bloc.dart';
import '../models/form_model.dart';
import '../models/post_model.dart';
import '../widgets/custom_loading2.dart';
import '../widgets/sign_form/signform_body.dart';

class SignFormPage extends StatefulWidget {
  final PostModel post;
  final UserModel user;
  const SignFormPage({
    super.key,
    required this.post,
    required this.user,
  });

  @override
  State<SignFormPage> createState() => _SignFormPageState();
}

class _SignFormPageState extends State<SignFormPage> {
  late CColor cColor;
  late List<FormModel> form = (jsonDecode(widget.post.form!) as List)
      .map((e) => FormModel.fromMap(e))
      .toList();
  late final SignFormBloc _bloc = SignFormBloc(form, widget.user);
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cColor = CColor.of(context);
  }

  onTap() {
    String? errorText = _bloc.checkFunc(form);
    if (errorText != null) {
      Messenger.dialog("有欄位尚未填寫完畢", errorText, context);
    } else {
      setState(() {
        isLoading = true;
      });
      _bloc.confirmSend(widget.user, widget.post, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: cColor.white,
            appBar: AppBar(
              backgroundColor: cColor.white,
              elevation: 0,
              iconTheme: IconThemeData(color: cColor.black, size: 20),
              title: MediumText(
                color: cColor.grey500,
                size: Dimensions.height2 * 8,
                text: '報名表單',
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.width2 * 10),
                child: Column(
                  children: [
                    // 表單選項
                    SignFormBody(
                      formList: form,
                      bloc: _bloc,
                    ),
                    SizedBox(height: Dimensions.height2 * 19),
                    //送出報名表單
                    SizedBox(
                      width: Dimensions.width5 * 30,
                      height: Dimensions.height2 * 20,
                      child: CupertinoButton(
                        color: cColor.primary,
                        onPressed: () => onTap(),
                        pressedOpacity: 0.8,
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: MediumText(
                              color: Colors.white,
                              size: Dimensions.height2 * 8,
                              text: "送出",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height5 * 15),
                    // 點擊連結下載
                    // const SignFormBottom(),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading) CustomLoadong2(),
      ],
    );
  }
}
