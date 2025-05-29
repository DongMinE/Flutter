import 'package:flutter/material.dart';
import 'package:gorouter_practice/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class PopBaseScreen extends StatelessWidget {
  const PopBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () async {
              //push로 들어간 페이지에서 pop으로 뒤로가면 결과를 받을 수 있음
              final result = await context.push('/pop/return');
              print(result);
            },
            child: Text('Push Pop Return Screen'),
          ),
        ],
      ),
    );
  }
}
