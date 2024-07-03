import 'package:hive/hive.dart';

class ToDoDatabase {
  List items = [];

  final myBox = Hive.box("myBox");

  void createInitialData() {
    items = [
      ["Make ToDO App", true],
      ["Take Rest", false],
      ["Class at 2", false],
      ["xyz", true]
    ];
  }

  void loadData() {
    items = myBox.get("ITEMS");
  }

  void updateDatabase() {
    myBox.put("ITEMS", items);
  }
}
