import 'package:flutter/material.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';

class AddOther extends StatefulWidget {
  final AddPostPageBloc bloc;
  const AddOther({
    super.key,
    required this.bloc,
  });

  @override
  State<AddOther> createState() => _AddOtherState();
}

class _AddOtherState extends State<AddOther> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
