import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/model/shopping_item_model.dart';

final shoppingListProvider2 =
    NotifierProvider<ShoppingListNotifier, List<ShoppingItemModel>>(
  ShoppingListNotifier.new,
);

class ShoppingListNotifier extends Notifier<List<ShoppingItemModel>> {
  @override
  List<ShoppingItemModel> build() {
    return [
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
    ];
  }

  void toggleHasBougth({required String name}) {
    state = state
        .map((e) => e.name == name ? e.copyWith(hasBougth: !e.hasBougth) : e)
        .toList();
  }
}
