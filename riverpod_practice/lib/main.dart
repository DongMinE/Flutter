import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/screen/home_screen.dart';

void main() {
  runApp(
    // riverpod사용하기 위해서는 필수
    ProviderScope(
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
