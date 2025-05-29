import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ListView(
        children: [
          ElevatedButton(onPressed: () {}, child: Text('Go to private Route'))
        ],
      ),
    );
  }
}
