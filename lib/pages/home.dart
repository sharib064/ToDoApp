// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:todo_app/pages/dialog_box.dart';
import 'package:todo_app/pages/itemtile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List items = [
    ["Make ToDO App", true],
    ["Take Rest", false],
    ["Class at 2", false],
    ["xyz", true]
  ];

  final myController = TextEditingController();
  int selectedIndex = 0;
  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void changedChecked(int index, bool? value) {
    setState(() {
      items[index][1] = !items[index][1];
    });
  }

  void taskDelete(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void savedTask() {
    setState(() {
      items.add([myController.text, false]);
      myController.clear();
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
    List completedItems = items.where((item) => item[1]).toList();

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
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ItemTile(
                  task: items[index][0],
                  completed: items[index][1],
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
                      items.indexOf(completedItems[index]), value),
                  taskDeleted: (value) =>
                      taskDelete(items.indexOf(completedItems[index])),
                );
              },
            ),
    );
  }
}
