import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    //하단바 이용하기 위한 컨트롤러, SingleTickerProviderStateMixin 필요
    controller = TabController(length: 4, vsync: this);
    //리스너 추가해서 탭이동 애니메이션이랑 선택된 탭 동기화
    controller.addListener(tabLister);
  }

  @override
  void dispose() {
    controller.removeListener(tabLister);
    super.dispose();
  }

  void tabLister() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜러버리',
      //child는 맨 마지막에 넣는걸 추천
      //child container는 없어도 되는 듯
      //TabBarView: 한화면에서 탭이동 가능한 화면
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          RestaurantScreen(),
          Center(child: Container(child: Text('음식'))),
          Center(child: Container(child: Text('주문'))),
          Center(child: Container(child: Text('프로필'))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: BODY_BORDER_COLOR,
        selectedItemColor: PRIMART_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        //색만 바뀌는 바 타입
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            controller.animateTo(index);
          });
        },
        //현재 탭 표시, TabController의 index를 받음
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
