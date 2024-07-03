import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class ItemTile extends StatelessWidget {
  final String task;
  final bool completed;
  Function(bool?)? onChanged;
  Function(BuildContext?)? taskDeleted;
  ItemTile(
      {super.key,
      required this.task,
      required this.completed,
      required this.onChanged,
      required this.taskDeleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Slidable(
          endActionPane: ActionPane(motion: const StretchMotion(), children: [
            SlidableAction(
              onPressed: taskDeleted,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(5),
            )
          ]),
          child: Container(
            padding:
                const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 8),
            decoration: BoxDecoration(
                color: completed ? Colors.green : Colors.pinkAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Checkbox(
                  value: completed,
                  onChanged: onChanged,
                  activeColor: Colors.green,
                  side: const BorderSide(color: Colors.white, width: 1.5),
                ),
                Text(
                  task,
                  style: TextStyle(
                      color: Colors.white,
                      decoration: completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                )
              ],
            ),
          ),
        ));
  }
}
