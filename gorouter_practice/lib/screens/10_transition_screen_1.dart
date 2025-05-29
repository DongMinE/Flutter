import 'package:flutter/material.dart';
import 'package:gorouter_practice/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class TransitionScreen1 extends StatelessWidget {
  const TransitionScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: Container(
        color: Colors.red,
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/transition/detail');
              },
              child: Text('Go Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
