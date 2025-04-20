import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:instagram/Feed.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      "https://devclass.devstory.co.kr/flutter-basic/2/insta-cat1.jpg",
      "https://devclass.devstory.co.kr/flutter-basic/2/insta-cat2.jpg",
      "https://devclass.devstory.co.kr/flutter-basic/2/insta-cat3.jpg",
      "https://devclass.devstory.co.kr/flutter-basic/2/insta-cat4.jpg",
      "https://devclass.devstory.co.kr/flutter-basic/2/insta-cat5.jpg",
      "https://devclass.devstory.co.kr/flutter-basic/2/insta-cat6.jpg",
      "https://devclass.devstory.co.kr/flutter-basic/2/insta-cat7.gif",
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.camera, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.paperplane, color: Colors.black),
            onPressed: () {},
          )
        ],
        title: Image.asset(
          'assets/logo.png',
          height: 32,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index]; // index에 해당하는 이미지
          return Feed(imageUrl: image); // imageUrl 전달
        },
      ),
    );
  }
}
