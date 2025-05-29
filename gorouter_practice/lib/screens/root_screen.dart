import 'package:flutter/material.dart';
import 'package:gorouter_practice/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          // 일반 GoRouter 이동
          ElevatedButton(
            onPressed: () {
              context.go('/basic');
            },
            child: Text('Go Basic'),
          ),
          // 네임드 라우트 이동
          ElevatedButton(
            onPressed: () {
              context.goNamed('named_screen');
            },
            child: Text('Go Named'),
          ),
          // 푸시 라우트 이동
          ElevatedButton(
            onPressed: () {
              context.go('/push');
            },
            child: Text('Go Push'),
          ),
          // 팝 라우트 이동
          ElevatedButton(
            onPressed: () {
              context.go('/pop');
            },
            child: Text('Go Pop'),
          ),
          // 경로 파라미터 이동
          ElevatedButton(
            onPressed: () {
              context.go('/path_param/456');
            },
            child: Text('Go Path Param'),
          ),
          // 쿼리 파라미터 이동
          ElevatedButton(
            onPressed: () {
              context.go('/query_param');
            },
            child: Text('Go Query Parameter'),
          ),
          // 중첩 라우트 이동
          ElevatedButton(
            onPressed: () {
              context.go('/nested/a');
            },
            child: Text('go Nested'),
          ),
        ],
      ),
    );
  }
}
