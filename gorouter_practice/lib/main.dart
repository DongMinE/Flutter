import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter_practice/route/router.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
    );
  }
}
