import 'package:flutter/material.dart';
import 'package:gorouter_practice/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class QueryParameterScreen extends StatelessWidget {
  const QueryParameterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          Text('현재 쿼리 파라미터: ${GoRouterState.of(context).uri.queryParameters}'),
          // /query_param?name=codefac&age=10 이렇게 이동하면 쿼리 파라미터를 받을 수 있음
          ElevatedButton(
            onPressed: () {
              context.go(
                Uri(
                  path: '/query_param',
                  queryParameters: {
                    'name': 'codefac',
                    'age': '32',
                  },
                ).toString(),
              );
            },
            child: Text('Query Parameter'),
          ),
        ],
      ),
    );
  }
}
