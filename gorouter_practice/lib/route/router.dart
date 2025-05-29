import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter_practice/screens/10_transition_screen_1.dart';
import 'package:gorouter_practice/screens/10_transition_screen_2.dart';
import 'package:gorouter_practice/screens/11_error_screen.dart';
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

bool authState = false;

final router = GoRouter(
  // 리다이렉트 방법 1 (조건필요)
  redirect: (context, state) {
    if (state.fullPath == '/login/private' && !authState) {
      return '/login';
    }
    return null;
  },
  routes: [
    // 리다이렉트 방법 2 (하위 페이지 이동시 경로 보고 조건없이 리다이렉트)
    GoRoute(
      path: 'login2',
      builder: (context, state) {
        return LoginScreen();
      },
      routes: [
        GoRoute(
          path: 'private',
          builder: (context, state) {
            return PrivateScreen();
          },
          redirect: (context, state) {
            if (!authState) {
              return '/login2';
            }
            return null;
          },
        ),
      ],
    ),
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
        GoRoute(
          path: 'query_param',
          builder: (context, state) {
            return QueryParameterScreen();
          },
        ),
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
        GoRoute(
          path: 'transition',
          builder: (context, state) {
            return TransitionScreen1();
          },
          routes: [
            GoRoute(
              path: 'detail',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(seconds: 3),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: TransitionScreen2(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    return ErrorScreen(error: state.error.toString());
  },
  debugLogDiagnostics: true,
);
