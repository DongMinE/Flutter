import 'package:flutter/material.dart';

class TodoBox extends StatefulWidget {
  bool isDone = false;
  double size;
  final String todoText;

  TodoBox({
    required this.size,
    required this.todoText,
    super.key,
  });

  @override
  State<TodoBox> createState() => _TodoBoxState();
}

class _TodoBoxState extends State<TodoBox> {
  Widget checkBox() {
    return Checkbox(
        value: widget.isDone,
        onChanged: (bool? value) {
          setState(() {
            widget.isDone = value!;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Row(
              children: [
                checkBox(),
                Expanded(
                  child: Text(
                    widget.todoText,
                    style: TextStyle(
                        decoration: widget.isDone == true
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontSize: 20),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.amber,
                    ))
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
