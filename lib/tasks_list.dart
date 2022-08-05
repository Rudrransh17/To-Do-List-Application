import 'package:intl/intl.dart';

class TodoItem {
  String title;
  bool done;
  DateTime date;

  TodoItem({required this.title, required this.done, required this.date});

  toJSONEncodable() {
    Map<String, dynamic> m = {};

    m['title'] = title;
    m['done'] = done;
    m['date'] = DateFormat("yyyy-MM-dd hh:mm:ss").format(date);

    return m;
  }
}

class TodoList {
  List<TodoItem> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
