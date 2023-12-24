import 'package:flutter/material.dart';
import 'package:upoint/models/post_model.dart';

class SearchPageBloc extends ChangeNotifier {
  // 使用数据创建PostModel列表
  List<PostModel> postList = List.generate(3, (index) {
    List actImages = [
      "https://images.unsplash.com/photo-1682687221175-fd40bbafe6ca?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D",
      "https://plus.unsplash.com/premium_photo-1700782893131-1f17b56098d0?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8",
      "https://images.unsplash.com/photo-1701453831008-ea11046da960?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHx8",
    ];
    List actTitle = ['3D雷雕工作坊', '創業計畫書工作坊', '投資人的眼光'];
    List actOrganizer = ['中原大學育成中心', '中原大學學發中心', '中原大學通識中心'];

    return PostModel(
      photos: actImages,
      title: actTitle[index],
      organizer: actOrganizer[index],
      reward: "麥當勞折價券",
      content:
          "Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate!Today is a wonderful day that ChongYuan University hold a huge activity in luhoulo ,and welcome every students & teachers participate! ",
    );
  });
}
