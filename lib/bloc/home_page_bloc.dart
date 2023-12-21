import 'package:flutter/material.dart';
import 'package:upoint/bloc/activity_body_bloc.dart';
import 'package:upoint/bloc/shop_body_bloc.dart';

class HomePageBloc with ChangeNotifier {
  // List<PostListBloc> postListBlocs = [];
  List tabList = ["找活動","找美食"];
  late TabController tabController;
  ActivityBodyBloc activityBodyBloc = ActivityBodyBloc();
  ShopBodyBloc shopBodyBloc = ShopBodyBloc();

  HomePageBloc(){
    // createBlocs(tabList.length);
  }

  // void createBlocs(int length) {
  //   for (int index = 0; index < length; index++) {
  //     final bloc = PostListBloc('homeBloc${index.toString()}'); // 創建一個新的 PostListBloc
  //     postListBlocs.add(bloc); // 將新的 PostListBloc 添加到列表中
  //   }
  // }

}