import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NestedScreen extends StatelessWidget {
  final Widget child;

  const NestedScreen({
    required this.child,
    super.key,
  });

  int getIndex(BuildContext context) {
    final uri = GoRouterState.of(context).uri;
    if (uri.path == '/nested/a') {
      return 0;
    } else if (uri.path == '/nested/b') {
      return 1;
    } else if (uri.path == '/nested/c') {
      return 2;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${GoRouterState.of(context).uri.path}'),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: getIndex(context),
        onTap: (index) {
          if (index == 0) {
            context.go('/nested/a');
          } else if (index == 1) {
            context.go('/nested/b');
          } else if (index == 2) {
            context.go('/nested/c');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'person',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'notifications',
          ),
        ],
      ),
    );
  }
}
