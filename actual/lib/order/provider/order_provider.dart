import 'package:actual/order/model/order_model.dart';
import 'package:actual/order/model/post_order_body.dart';
import 'package:actual/order/repository/order_repository.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderMoodel>>(
  (ref) {
    final repo = ref.watch(orderRepositoryProvider);
    return OrderStateNotifier(
      ref: ref,
      repository: repo,
    );
  },
);

class OrderStateNotifier extends StateNotifier<List<OrderMoodel>> {
  final OrderRepository repository;
  final Ref ref;

  OrderStateNotifier({
    required this.repository,
    required this.ref,
  }) : super([]);

  Future<bool> postOrder() async {
    final uuid = Uuid();
    final id = uuid.v4();
    final state = ref.read(basketProvider);
    try {
      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map(
                (e) => PostOrderBodyProduct(
                  productId: e.product.id,
                  count: e.count,
                ),
              )
              .toList(),
          totalPrice: 50000,
          createdAt: DateTime.now().toString(),
        ),
      );
      print('resp: $resp');

      return true;
    } catch (e) {
      return false;
    }
  }
}
