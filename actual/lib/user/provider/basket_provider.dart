import 'package:actual/product/model/product_model.dart';
import 'package:actual/user/model/basket_item_model.dart';
import 'package:actual/user/model/patch_basket_body.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>(
  (ref) {
    final repository = ref.watch(userMeRepositoryProvider);
    return BasketProvider(
      repository: repository,
    );
  },
);

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  final updateBasketDebounce = Debouncer(
    Duration(seconds: 1),
    initialValue: null,
    checkEquality: false,
  );

  BasketProvider({
    required this.repository,
  }) : super([]) {
    updateBasketDebounce.values.listen((event) {
      patchBasket();
    });
  }

  Future<void> getBasket() async {
    final resp = await repository.getBasket();
    state = resp;
  }

  Future<void> addToBasket({required ProductModel product}) async {
    //1) 아직 장바구니에 해당되는 상품이 없다면 상품추가
    //2) 장바구니에 이미 있다면 +1
    final exists = state.firstWhereOrNull((e) => e.product.id == product.id);

    if (exists != null) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        )
      ];
    }
    // 다른 기능들은 요청을 보내고 응답이 오면 캐시를 업데이트
    // 장바구니 담기 기능은 엄청 중요한 정보가 아니라고 판단되면
    // 요청을 보내고 응답이 오면 캐시를 업데이트
    // 5초가 걸린다고 치면 일단 바로 UI와 캐시를 업데이트 하고 5초 뒤 실제 응답이 감
    // 이를 Optimistic response 라고 함
    updateBasketDebounce.setValue(null);
  }

  Future<void> patchBasket() async {
    try {
      await repository.patchBasket(
        body: PatchBasketBody(
          basket: state
              .map((e) => PatchBasketBodyBasket(
                    productId: e.product.id,
                    count: e.count,
                  ))
              .toList(),
        ),
      );
    } catch (e) {
      print('message: $e');
      state = [];
    }
  }

  Future<void> removeFromBasket({
    // true면 count에 관계없이 삭제
    bool isDelete = false,
    required ProductModel product,
  }) async {
    // 1) 장바구니에 상품이 존재할때
    //    1-1) 상품의 카운트가 1보다 크면 -1
    //    1-2) 상품의 카운트가 1이면 상품 제거
    // 2) 장바구니에 상품이 존재하지 않을때
    //    2-1) 즉시 함수 반환하고 아무것도 하지 않음
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count - 1,
                  )
                : e,
          )
          .toList();
    }
    updateBasketDebounce.setValue(null);
  }
}
