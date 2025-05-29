import 'package:go_router/go_router.dart';
import 'package:gorouter_practice/screens/1_basic_screen.dart';
import 'package:gorouter_practice/screens/2_named_screen.dart';
import 'package:gorouter_practice/screens/3_push_screen.dart';
import 'package:gorouter_practice/screens/4_pop_base_screen.dart';
import 'package:gorouter_practice/screens/5_pop_return_screen.dart';
import 'package:gorouter_practice/screens/6_path_param_screen.dart';
import 'package:gorouter_practice/screens/7_query_parameter.dart';
import 'package:gorouter_practice/screens/8_nested_child_screen.dart';
import 'package:gorouter_practice/screens/8_nested_screen.dart';
import 'package:gorouter_practice/screens/9_login_screen.dart';
import 'package:gorouter_practice/screens/9_private_screen.dart';
import 'package:gorouter_practice/screens/root_screen.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      return RootScreen();
    },
    routes: [
      GoRoute(
        path: 'basic',
        builder: (context, state) {
          return BasicScreen();
        },
      ),
      GoRoute(
        path: 'named',
        name: 'named_screen',
        builder: (context, state) {
          return NamedScreen();
        },
      ),
      GoRoute(
        path: 'push',
        builder: (context, state) {
          return PushScreen();
        },
      ),
      GoRoute(
        path: 'pop',
        builder: (context, state) {
          return PopBaseScreen();
        },
        routes: [
          GoRoute(
            path: 'return',
            builder: (context, state) {
              return PopReturnScreen();
            },
          ),
        ],
      ),
      //:id와 :name으로 이동하는 라우터는 서로 다른 경로이지만 같은 위젯을 공유가능
      GoRoute(
        path: 'path_param/:id',
        builder: (context, state) {
          return PathParamScreen();
        },
        routes: [
          GoRoute(
            path: ':name',
            builder: (context, state) {
              return PathParamScreen();
            },
          ),
        ],
      ),
      // 쿼리 파라미터 이동
      GoRoute(
        path: 'query_param',
        builder: (context, state) {
          return QueryParameterScreen();
        },
      ),
      // 중첩 라우트
      ShellRoute(
        builder: (context, state, child) {
          return NestedScreen(child: child);
        },
        routes: [
          GoRoute(
            path: 'nested/a',
            builder: (_, state) {
              return NestedChildScreen(routeName: '/nested/a');
            },
          ),
          GoRoute(
            path: 'nested/b',
            builder: (_, state) {
              return NestedChildScreen(routeName: '/nested/b');
            },
          ),
          GoRoute(
            path: 'nested/c',
            builder: (_, state) {
              return NestedChildScreen(routeName: '/nested/c');
            },
          ),
        ],
      ),
      GoRoute(
        path: 'login',
        builder: (context, state) {
          return LoginScreen();
        },
        routes: [
          GoRoute(
            path: 'private',
            builder: (context, state) {
              return PrivateScreen();
            },
          ),
        ],
      ),
    ],
  ),
]);
