import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/user_simple_preference.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String text;
  final String hintText;
  final bool autoFocus;
  final TextEditingController controller;
  final Function() setState;
  const SearchWidget({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.text,
    required this.autoFocus,
    required this.controller,
    required this.setState,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;
    Color hintColor = Theme.of(context).hintColor;

    return Container(
      height: Dimensions.height5 * 9,
      margin: EdgeInsets.symmetric(vertical: Dimensions.height5 * 3),
      padding: EdgeInsets.only(
        left: Dimensions.width2 * 3,
        right: Dimensions.width2 * 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        onSubmitted: (value) {
          UserSimplePreference.setSearchPostHistory(
            value,
          );
          widget.setState();
        },
        autofocus: widget.autoFocus,
        controller: widget.controller,
        cursorColor: hintColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            Icons.search_outlined,
            color: Colors.grey,
            size: Dimensions.height5 * 5,
          ),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: Dimensions.height5 * 5,
                  ),
                  onTap: () {
                    widget.controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus();
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
        ),
        onChanged: widget.onChanged,
        style: style,
      ),
    );
  }
}
