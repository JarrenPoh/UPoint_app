class PostModel {
  List? photos;
  String? organizer;
  String? title;
  DateTime? date;
  String? startTime;
  String? endTime;
  String? content;
  String? reward;
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
    this.reward,
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
      "reward": cart.reward,
      "link": cart.link,
      "postId": cart.postId,
      "datePublished": cart.datePublished,
    };
  }

  static PostModel fromMap(Map map) {
    return PostModel(
      photos: map['photos'],
      organizer: map['organizer'],
      title: map['title'],
      date: map['date'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      content: map['content'],
      reward: map['reward'],
      link: map['link'],
      postId: map['postId'],
      datePublished: map['datePublished'],
    );
  }
}
