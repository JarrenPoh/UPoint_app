import 'package:flutter/material.dart';

class HomePageBloc with ChangeNotifier {
  List<ScrollController> scrollControllerList = [];
  List tabList = ["找活動","找美食"];
  late TabController tabController;

  HomePageBloc(){
    createScroll(tabList.length);
  }

  void createScroll(int length) {
    for (int index = 0; index < length; index++) {
      final scroll = ScrollController(); // 創建一個新的 PostListBloc
      scrollControllerList.add(scroll); // 將新的 PostListBloc 添加到列表中
    }
  }

}