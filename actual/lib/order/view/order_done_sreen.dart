import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDoneScreen extends StatelessWidget {
  static String routeName = 'orderDone';

  const OrderDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.thumb_up_alt_outlined,
          color: PRIMARY_COLOR,
          size: 50.0,
        ),
        const SizedBox(height: 32.0),
        Text(
          '결제가 완료되었습니다.',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32.0),
        ElevatedButton(
          onPressed: () {
            context.goNamed(RootTab.routeName);
          },
          child: Text('홈으로'),
        )
      ],
    ));
  }
}
