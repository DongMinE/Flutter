import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    //interceptors로 CustomInterceptor를 실행하여 요청전 조건을 실행
    //repository에는 header 어노테이션을 추가
    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    final resp =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
            .paginate();

    // dio.dart에서 interceptor할 때 header에 true로 넣어줘서 필요없음
    // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // final resp = await dio.get(
    //   'http://$ip/restaurant',
    //   options: Options(
    //     headers: {
    //       'authorization': 'Bearer $accessToken',
    //     },
    //   ),
    // );
    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List<RestaurantModel>>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final pItem = snapshot.data![index];
                  /* 
                    item을 명시하는 이유는 fromJson을 직접 파싱해줘야 했는데
                    retrofit을 사용해서 g파일 내부에서 return값이 FromJson을 해준 값
                  */
                  // final pItem = RestaurantModel.fromJson(
                  //   item,
                  // );
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                            id: pItem.id,
                            name: pItem.name,
                          ),
                        ),
                      );
                    },
                    child: RestaurantCard.fromModel(
                      model: pItem,
                    ),
                  );
                  //parsed
                  // final pItem = RestaurantModel(
                  //   id: item['id'],
                  //   name: item['name'],
                  //   thumbUrl: 'http://$ip${item['thumbUrl']}',
                  //   tags: List<String>.from(item['tags']),
                  //   priceRange: RestaurantPriceRange.values
                  //       .firstWhere((e) => e.name == item['priceRange']),
                  //   ratings: item['ratings'],
                  //   ratingsCount: item['ratingsCount'],
                  //   deliveryTime: item['deliveryTime'],
                  //   deliveryFee: item['deliveryFee'],
                  // );

                  // return RestaurantCard(
                  //   image: Image.network(
                  //     pItem.thumbUrl,
                  //     fit: BoxFit.cover,
                  //   ),
                  //   name: pItem.name,
                  //   tags: pItem.tags,
                  //   ratingsCount: pItem.ratingsCount,
                  //   deliveryTime: pItem.deliveryTime,
                  //   deliveryFee: pItem.deliveryFee,
                  //   raings: pItem.ratings,
                  // );
                },
                separatorBuilder: (_, index) {
                  return SizedBox(height: 16.0);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
