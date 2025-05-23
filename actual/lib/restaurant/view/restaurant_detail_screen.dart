import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  final String name;

  const RestaurantDetailScreen({
    required this.id,
    required this.name,
    super.key,
  });

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    //interceptors로 CustomInterceptor를 실행하여 요청전 조건을 실행
    //repository에는 header 어노테이션을 추가
    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    final repository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
    return repository.getRestaurantDetail(id: id);

    /*
      아래의 코드로 사용해야하는걸 retrofit를 사용해 api요청을 자동화 하며
      repository에 dio와 url을 명시하고 getRestaurantDetail을 반환받음
    */

    // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    // final resp = await dio.get(
    //   'http://$ip/restaurant/$id',
    //   options: Options(
    //     headers: {
    //       'authorization': 'Bearer $accessToken',
    //     },
    //   ),
    // );
    // return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: name,
      //retrofit으로 반환받는 타입이 RestaurantDetailModel이므로 Map(String, dynamic)이 아님
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          /* 
            item을 명시하는 이유는 fromJson을 직접 파싱해줘야 했는데
            retrofit을 사용해서 g파일 내부에서 return값이 FromJson을 해준 값
          */
          // final item = RestaurantDetailModel.fromJson(snapshot.data!);
          return CustomScrollView(
            //Sliver는 ListView에 비해 유연하며 복잡할수록 유리
            //Sliver는 CustomScrollView와 함께 사용
            slivers: [
              renderTop(
                model: snapshot.data!,
              ),
              renderLabel(),
              renderProduct(products: snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  //Sliver의 자식은 Sliver만 받을 수 있으며 일반 위젯을 넣기위해서는 SliverToBoxAdapter가 필요
  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  renderProduct({required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      // ListView, SliverList, SliverChildListDelegate는 모든 아이템 빌드
      // ListView.builder, SliverChildBuilderDelegate는 Lazy빌드
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(
                model: model,
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
