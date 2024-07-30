

enum ActFilterType { ORGANIZER, REWARD, TYPE }

class FilterModel {
  final String index;
  final Future<Map<String, dynamic>> Function()? future;
  final bool needFuture;
  String filter;
  final List<dynamic> list;
  final Map<String, int> count;
  final ActFilterType type;
  final String hintText;

  FilterModel({
    required this.index,
    required this.future,
    required this.needFuture,
    required this.filter,
    required this.list,
    required this.count,
    required this.type,
    required this.hintText,
  });
}
