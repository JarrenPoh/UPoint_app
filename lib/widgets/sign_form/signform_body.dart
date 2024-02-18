import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint/models/form_model.dart';
import 'package:upoint/models/option_model.dart';
import '../../bloc/sign_form_bloc.dart';
import '../../globals/colors.dart';
import '../../globals/medium_text.dart';
import 'long_field.dart';
import 'short_field.dart';

class SignFormBody extends StatelessWidget {
  final List<FormModel> formList;
  final SignFormBloc bloc;
  const SignFormBody({
    super.key,
    required this.formList,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final CColor cColor = CColor.of(context);
    var _count = 0;

    return Column(
      children: List.generate(
        formList.length,
        (l) {
          FormModel form = formList[l];
          return Column(
            children: [
              const SizedBox(height: 36),
              _title(form.title, context),
              const SizedBox(height: 8),
              Column(
                children: List.generate(
                  form.options.length,
                  (i) {
                    _count++;
                    OptionModel option = form.options[i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 17),
                        Row(
                          children: [
                            if (option.necessary)
                              const Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            MediumText(
                              color: cColor.grey500,
                              size: 16,
                              text: option.subtitle,
                            ),
                          ],
                        ),
                        // 說明文字
                        Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 10),
                          child: option.explain != null
                              ? MediumText(
                                  color: cColor.grey400,
                                  size: 14,
                                  text: option.explain!,
                                )
                              : const SizedBox(),
                        ),
                        _choseWidget(option, bloc, _count - 1),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _choseWidget(OptionModel option, SignFormBloc bloc, int index) {
    List<String> shortList = ["single", "multi", "gender", "meal"];
    if (shortList.contains(option.type)) {
      return ShortField(
        option: option,
        onChanged: (e) => bloc.onShortFieldChanged(e, index),
        initList: bloc.signForm[index]["value"] == ""
            ? []
            : bloc.signForm[index]["value"],
      );
    } else {
      return LongField(
        option: option,
        initText: bloc.signForm[index]["value"],
        onChanged: (e) => bloc.onLongFieldChanged(e, index),
      );
    }
  }

  Widget _title(String text, BuildContext context) {
    final CColor cColor = CColor.of(context);
    return Row(
      children: [
        Container(
          width: 8,
          height: 22,
          color: cColor.primary,
        ),
        const SizedBox(width: 12),
        MediumText(
          color: cColor.grey500,
          size: 18,
          text: text,
        ),
      ],
    );
  }
}
