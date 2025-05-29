import 'package:flutter/material.dart';
import 'package:gorouter_practice/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class PathParamScreen extends StatelessWidget {
  const PathParamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          Text('path param: ${GoRouterState.of(context).pathParameters}'),
          ElevatedButton(
            onPressed: () {
              context.go('/path_param/456/codefac');
            },
            child: Text('Go one More'),
          ),
        ],
      ),
    );
  }
}
