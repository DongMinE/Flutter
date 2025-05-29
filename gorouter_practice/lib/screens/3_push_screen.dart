import 'package:flutter/material.dart';
import 'package:gorouter_practice/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class PushScreen extends StatelessWidget {
  const PushScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              // 현재 생성된 화면을 스택에 쌓음
              // 뒤로가면 들어왔던 화면으로 이동
              context.push('/basic');
            },
            child: Text('Push Basic'),
          ),
          ElevatedButton(
            onPressed: () {
              // 라우터에 정의된 순서의 이전화면으로 이동
              // 어떤 페이지에서 왔는지는 상관하지 않음
              context.go('/basic');
            },
            child: Text('go Named'),
          ),
        ],
      ),
    );
  }
}
