import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';

// ignore: must_be_immutable
class EditTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final Function onChanged;
  bool isDone;
  int maxLines;
  int maxLength;
  EditTextField({
    super.key,
    required this.focusNode,
    required this.textEditingController,
    required this.isDone,
    required this.onChanged,
    required this.maxLines,
    required this.maxLength,
  });

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.height5 * 1,
        horizontal: Dimensions.width5 * 3,
      ),
      child: TextField(
        focusNode: widget.focusNode,
        controller: widget.textEditingController,
        onChanged: (value) {
          widget.onChanged();
        },
        style: TextStyle(color: onSecondary),
        keyboardType: TextInputType.text,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          // errorText: emptyEnter ? '不可為空' : null,
          errorStyle: TextStyle(fontWeight: FontWeight.bold),
          // hintText: hintText,
          counterText: '',
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: false,
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}
