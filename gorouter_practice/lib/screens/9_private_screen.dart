import 'package:flutter/material.dart';
import 'package:gorouter_practice/layout/default_layout.dart';

class PrivateScreen extends StatelessWidget {
  const PrivateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          Text('Private Screen'),
        ],
      ),
    );
  }
}
