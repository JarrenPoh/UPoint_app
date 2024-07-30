import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:upoint/globals/colors.dart';
import '../../globals/dimension.dart';
import '../../globals/medium_text.dart';
import '../../models/filter_model.dart';
import '../custom_loading2.dart';

class DropDownFilter extends StatefulWidget {
  final FilterModel filterModel;
  final Function(String?) onChanged;

  const DropDownFilter({
    super.key,
    required this.filterModel,
    required this.onChanged,
  });

  @override
  State<DropDownFilter> createState() => _DropDownFilterState();
}

class _DropDownFilterState extends State<DropDownFilter> {
  late final CColor cColor = CColor.of(context);
  Future<Map<String, dynamic>>? _futureCache;
  String? searchText;

  @override
  void initState() {
    super.initState();
    if (widget.filterModel.future != null) {
      _futureCache = widget.filterModel.future!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filterModel.future == null && widget.filterModel.count.isNotEmpty) {
      return _buildDropdown(
        context,
        {
          "list": widget.filterModel.list,
          "count": widget.filterModel.count,
        },
      );
    } else {
      return FutureBuilder<Map<String, dynamic>>(
        future: _futureCache,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  CustomLoadong2();
          } else if (snapshot.hasData) {
            Map<String, dynamic> map = snapshot.data!;
            return _buildDropdown(context, map);
          }
          return Container();
        },
      );
    }
  }

  Widget _buildDropdown(BuildContext context, Map<String, dynamic> map) {
    List<String> items = List<String>.from(map["list"] ?? []);
    Map<String, int> count = Map<String, int>.from(map["count"] ?? {});
    return Container(
      height: Dimensions.height2 * 24,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: cColor.white,
        border: Border.all(color: cColor.grey200),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(1, 1),
            blurRadius: 10,
            spreadRadius: 0,
          )
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String?>(
          value: searchText,
          hint: MediumText(
            color: cColor.grey500,
            size: 14,
            text: widget.filterModel.hintText,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          isExpanded: true,
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {
              searchText = value;
            });
          },
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width2 * 4),
          ),
          iconStyleData: IconStyleData(
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: Dimensions.height2 * 12,
            iconEnabledColor: cColor.grey400,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: Dimensions.screenHeight / 3,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: cColor.white,
            ),
            offset: const Offset(0, 0),
          ),
          items: items.map((e) {
            return DropdownMenuItem<String?>(
              value: e,
              child: SizedBox(
                width: double.infinity,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontFamily: "NotoSansMedium"),
                    children: [
                      TextSpan(
                        text: e,
                        style: TextStyle(
                          color: cColor.grey500,
                          fontSize: 14,
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: Dimensions.width5 * 2),
                      ),
                      TextSpan(
                        text: count[e].toString(),
                        style: TextStyle(
                          color: cColor.primary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
