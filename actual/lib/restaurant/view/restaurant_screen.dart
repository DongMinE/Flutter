import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/utils/pagination_utils.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  // Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
  /* 
    1. header를 일일이 넣어주기
  */
  // final resp = await dio.get(
  //   'http://$ip/restaurant',
  //   options: Options(
  //     headers: {
  //       'authorization': 'Bearer $accessToken',
  //     },
  //   ),
  // );

  /* 
    2. provider를 사용해 watch로 동일한 인스턴스 사용하기
  */
  // final dio = ref.watch(dioProvider);
  // dio.dart에서 interceptor할 때 header에 true로 넣어줘서 필요없음
  // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  // dio.interceptors.add(
  //   CustomInterceptor(storage: storage),
  // );
  // final resp =
  //     await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
  //         .paginate();
  // return resp.data;

  /* 
    3. provider를 사용해 watch로 동일한 인스턴스 사용하기
  */
  // return ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: id);
  // }
  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListner);
  }

  void scrollListner() {
    PaginationUtils.paginate(
        controller: controller,
        provider: ref.read(restaurantProvider.notifier));
    // PaginationUtils에 페이지네이션을 oop함
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치일 때 추가요청
    // if (controller.offset > controller.position.maxScrollExtent - 300) {
    //   ref.read(restaurantProvider.notifier).paginate(
    //         fetchMore: true,
    //       );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);
    //완전 처음
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    //에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }
    // CursorPagination
    // CursorPaginationFetcingMore
    // CursorPaginationRefetching

    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Center(
              child: data is CursorPaginationFetchingMore
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text('마지막 페이지입니다.'),
                    ),
            );
          }
          final pItem = cp.data[index];
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
      ),
    );
  }
}
