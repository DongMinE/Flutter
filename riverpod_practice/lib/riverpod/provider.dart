import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/model/shopping_item_model.dart';
import 'package:riverpod_practice/riverpod/state_notifier_provider.dart';

final filterShoppingListProvider = Provider<List<ShoppingItemModel>>(
  (ref) {
    //기본값 필터 all과 제품 전부로 갖고있는 필터
    //이 두개를 watch하는 provider
    final filterState = ref.watch(filterProvider);
    final shoppingListState = ref.watch(shoppingListProvider);

    //필터 값에 따라 리스트를 보여주기
    if (filterState == FilterState.all) {
      return shoppingListState;
    }

    return shoppingListState
        .where(
          (element) => filterState == FilterState.spicy
              ? element.isSpicy
              : !element.isSpicy,
        )
        .toList();
  },
);

enum FilterState {
  notSpicy,
  spicy,
  all,
}

final filterProvider = StateProvider<FilterState>((ref) => FilterState.all);
