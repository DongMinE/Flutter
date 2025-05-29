import 'package:flutter/material.dart';
import 'package:gorouter_practice/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class PopReturnScreen extends StatelessWidget {
  const PopReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              //pop으로 생성한 곳(push로 들어간 페이지)에서 결과값을 받을 수 있음
              context.pop('codeFac');
            },
            child: Text('Pop'),
          ),
        ],
      ),
    );
  }
}
