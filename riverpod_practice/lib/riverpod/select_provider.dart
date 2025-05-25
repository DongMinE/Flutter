import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/model/shopping_item_model.dart';

final selectProvider = StateNotifierProvider<SelectNotifier, ShoppingItemModel>(
  (ref) => SelectNotifier(),
);

class SelectNotifier extends StateNotifier<ShoppingItemModel> {
  SelectNotifier()
      : super(
          ShoppingItemModel(
            name: '김치',
            quantity: 3,
            hasBougth: false,
            isSpicy: true,
          ),
        );

  toggleHasBougth() {
    // ShoppingItemModel에 특정 값만 바꾸는 copyWith를 만들어 둠
    // state = ShoppingItemModel(
    //   name: state.name,
    //   quantity: state.quantity,
    //   hasBougth: !state.hasBougth,
    //   isSpicy: state.isSpicy,
    // );
    state = state.copyWith(
      hasBougth: !state.hasBougth,
    );
  }

  toggleIsSpicy() {
    // ShoppingItemModel에 특정 값만 바꾸는 copyWith를 만들어 둠
    // state = ShoppingItemModel(
    //   name: state.name,
    //   quantity: state.quantity,
    //   hasBougth: state.hasBougth,
    //   isSpicy: !state.isSpicy,
    // );
    state = state.copyWith(
      isSpicy: !state.isSpicy,
    );
  }
}
