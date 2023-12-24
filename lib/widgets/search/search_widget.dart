import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String text;
  final String hintText;
  final bool autoFocus;
  const SearchWidget({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.text,
    required this.autoFocus,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();
  String _text = '';
  @override
  void initState() {
    super.initState();
    _text = widget.text;
    controller.text = _text;
    controller.addListener(() {
      if (controller.text.trim() == '') {
        setState(() {
          _text = '';
        });
      } else {
        setState(() {
          _text = controller.text.trim();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = _text.isEmpty ? styleHint : styleActive;
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
        autofocus: widget.autoFocus,
        controller: controller,
        cursorColor: hintColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            Icons.search_outlined,
            color: Colors.grey,
            size: Dimensions.height5 * 5,
          ),
          suffixIcon: _text.isNotEmpty
              ? GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: Dimensions.height5 * 5,
                  ),
                  onTap: () {
                    controller.clear();
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
