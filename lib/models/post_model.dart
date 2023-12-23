class PostModel {
  List? photos;
  String? organizer;
  String? title;
  DateTime? date;
  String? startTime;
  String? endTime;
  String? content;
  String? reWard;
  String? link;
  String? postId;
  DateTime? datePublished;

  PostModel({
    this.photos,
    this.organizer,
    this.title,
    this.date,
    this.startTime,
    this.endTime,
    this.content,
    this.reWard,
    this.link,
    this.postId,
    this.datePublished,
  });

  static Map toMap(PostModel cart) {
    return {
      "photos": cart.photos,
      "organizer": cart.organizer,
      "title": cart.title,
      "dateTime": cart.date,
      "startTime": cart.startTime,
      "endTime": cart.endTime,
      "content": cart.content,
      "reWard": cart.reWard,
      "link": cart.link,
      "postId": cart.postId,
      "datePublished": cart.datePublished,
    };
  }

  // static PostModel fromMap(Map map) {
  //   return PostModel(
  //     photos: map['photos'],
  //     gender: map['gender'],
  //     single: map['single'],
  //     chose: map['chose'],
  //     isChose: map['isChose'],
  //     initChose: map['initChose'],
  //     chose: map['chose'],
  //     isChose: map['isChose'],
  //     initChose: map['initChose'],
  //     chose: map['chose'],
  //     isChose: map['isChose'],
  //     initChose: map['initChose'],
  //   );
  // }
}
