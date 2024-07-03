// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/pages/database.dart';
import 'package:todo_app/pages/dialog_box.dart';
import 'package:todo_app/pages/itemtile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myBox = Hive.box("myBox");
  ToDoDatabase db = ToDoDatabase();
  final myController = TextEditingController();
  int selectedIndex = 0;
  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    if (myBox.get("ITEMS") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void changedChecked(int index, bool? value) {
    setState(() {
      db.items[index][1] = !db.items[index][1];
    });
    db.updateDatabase();
  }

  void taskDelete(int index) {
    setState(() {
      db.items.removeAt(index);
      db.updateDatabase();
    });
  }

  void savedTask() {
    setState(() {
      db.items.add([myController.text, false]);
      myController.clear();
      db.updateDatabase();
    });
    Navigator.of(context).pop();
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (context) => ShowDialogBox(
        controller: myController,
        onSaved: savedTask,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List completedItems = db.items.where((item) => item[1]).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        title: const Center(child: Text("T O D O   A P P")),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showDialogBox,
        backgroundColor: Colors.pinkAccent,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.grey[400],
          unselectedItemColor: Colors.white,
          onTap: changePage,
          currentIndex: selectedIndex,
          backgroundColor: Colors.pinkAccent,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: selectedIndex == 0 ? Colors.grey[400] : Colors.white,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.done,
                color: selectedIndex == 1 ? Colors.grey[400] : Colors.white,
              ),
              label: "Completed",
            ),
          ]),
      body: selectedIndex == 0
          ? ListView.builder(
              itemCount: db.items.length,
              itemBuilder: (context, index) {
                return ItemTile(
                  task: db.items[index][0],
                  completed: db.items[index][1],
                  onChanged: (value) => changedChecked(index, value),
                  taskDeleted: (value) => taskDelete(index),
                );
              },
            )
          : ListView.builder(
              itemCount: completedItems.length,
              itemBuilder: (context, index) {
                return ItemTile(
                  task: completedItems[index][0],
                  completed: completedItems[index][1],
                  onChanged: (value) => changedChecked(
                      db.items.indexOf(completedItems[index]), value),
                  taskDeleted: (value) =>
                      taskDelete(db.items.indexOf(completedItems[index])),
                );
              },
            ),
    );
  }
}
