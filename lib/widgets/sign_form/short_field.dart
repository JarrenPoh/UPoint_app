import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import '../../globals/colors.dart';
import '../../globals/medium_text.dart';
import '../../models/option_model.dart';

class ShortField extends StatefulWidget {
  final OptionModel option;
  final Function(List) onChanged;
  final List initList;
  const ShortField({
    super.key,
    required this.option,
    required this.onChanged,
    required this.initList,
  });

  @override
  State<ShortField> createState() => _ShortFieldState();
}

class _ShortFieldState extends State<ShortField> {
  String choseText = "";
  List radioList = ["gender", "meal", "single"];
  onTap(String text) {
    if (radioList.contains(widget.option.type)) {
      //單選只能有一個
      widget.initList.clear();
      widget.initList.add(text);
    } else {
      //多選要先看是不是有了
      if (widget.initList.contains(text)) {
        //移除
        widget.initList.removeWhere((e) => e == text);
      } else {
        //新增
        widget.initList.add(text);
      }
    }
    setState(() {});
    widget.onChanged(widget.initList);
  }

  late CColor cColor;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cColor = CColor.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: Dimensions.height5 * 3,
      children: List.generate(
        widget.option.body.length,
        (index) {
          bool isActive = widget.initList.contains(widget.option.body[index]);
          return Container(
            height: Dimensions.height2 * 22,
            margin: EdgeInsets.only(right: Dimensions.width2 * 11),
            decoration: BoxDecoration(
              border: Border.all(color: cColor.grey300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => onTap(widget.option.body[index]),
                  child: Container(
                    width: Dimensions.width2 * 10,
                    height: Dimensions.height2 * 10,
                    padding: const EdgeInsets.all(4),
                    margin:
                        EdgeInsets.symmetric(horizontal: Dimensions.width2 * 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        radioList.contains(widget.option.type) ? 10 : 5,
                      ),
                      border: Border.all(
                        color: isActive ? cColor.primary : cColor.grey300,
                      ),
                    ),
                    child: Icon(
                      radioList.contains(widget.option.type)
                          ? Icons.circle
                          : Icons.check,
                      size: Dimensions.height2 * 5,
                      color: isActive ? cColor.primary : Colors.transparent,
                    ),
                  ),
                ),
                MediumText(
                  color: cColor.grey500,
                  size: Dimensions.height2 * 8,
                  text: widget.option.body[index],
                ),
                const SizedBox(width: 7),
              ],
            ),
          );
        },
      ),
    );
  }
}
