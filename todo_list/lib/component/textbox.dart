import 'package:flutter/material.dart';

class TodoInput extends StatefulWidget {
  final Function(String value, double size) addTodo;
  double size;
  TodoInput({required this.addTodo, required this.size, super.key});

  @override
  State<TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput> {
  late TextEditingController _controller;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendText(String value) {
    widget.addTodo(value, widget.size);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Todo App",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30.0,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16.0,
        ),
        SizedBox(
          width: widget.size,
          child: TextField(
            controller: _controller, //컨트롤러는 위에서 선언한 컨트롤러
            decoration: const InputDecoration(
              border: OutlineInputBorder(), //border 생성
              labelText: "Write the TODO list", // 힌트 텍스트
            ),
            onSubmitted: sendText,
            maxLines: 3,
            focusNode: _focus,
          ),
        ),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  if (_controller.text != '') {
                    sendText(_controller.text);
                  }
                  _controller.clear();
                  _focus.unfocus();
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
