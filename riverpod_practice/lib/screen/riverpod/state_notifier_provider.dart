import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/model/shopping_item_model.dart';

final shoppngListProvider =
// 어떤 notifier인지와 해당 notifier가 관리하는 상태값
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItemModel>>(
  (ref) => ShoppingListNotifier(),
);

class ShoppingListNotifier extends StateNotifier<List<ShoppingItemModel>> {
  ShoppingListNotifier()
      : super(
          [
            ShoppingItemModel(
              name: '김치',
              quantity: 3,
              hasBougth: false,
              isSpicy: true,
            ),
            ShoppingItemModel(
              name: '라면',
              quantity: 8,
              hasBougth: false,
              isSpicy: true,
            ),
            ShoppingItemModel(
              name: '삼겹살',
              quantity: 30,
              hasBougth: false,
              isSpicy: false,
            ),
            ShoppingItemModel(
              name: '수박',
              quantity: 20,
              hasBougth: false,
              isSpicy: false,
            ),
            ShoppingItemModel(
              name: '시리얼',
              quantity: 4,
              hasBougth: false,
              isSpicy: false,
            ),
          ],
        );

  // ref.read(shoppngListProvider.notifier).toggleHasBougth()식으로 호출가능
  void toggleHasBougth({required String name}) {
    // state = StateNotifier<List<ShoppingItemModel>>에서 제공해주는 값
    state = state
        .map((e) => e.name == name
            ? ShoppingItemModel(
                name: e.name,
                quantity: e.quantity,
                hasBougth: !e.hasBougth,
                isSpicy: e.isSpicy,
              )
            : e)
        .toList();
  }
}
