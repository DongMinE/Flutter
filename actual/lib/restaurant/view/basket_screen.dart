import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/order/provider/order_provider.dart';
import 'package:actual/order/view/order_done_sreen.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return DefaultLayout(
        title: '장바구니',
        child: Center(
          child: Text(
            '장바구니가 비었습니다.',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final productPrice = basket.fold<int>(
      0,
      (p, n) => p + n.count * n.product.price,
    );
    final deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
        title: '장바구니',
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, index) => Divider(height: 32.0),
                    itemBuilder: (_, index) {
                      // return ProductCard(
                      //   image: basket[index].image,
                      //   name: basket[index].name,
                      //   detail: basket[index].detail,
                      //   price: basket[index].price,
                      //   id: basket[index].id,
                      // );
                      final model = basket[index];
                      return ProductCard.fromProductModel(
                        model: model.product,
                        onAdd: () {
                          ref.read(basketProvider.notifier).addToBasket(
                                product: model.product,
                              );
                        },
                        onSubtract: () {
                          ref.read(basketProvider.notifier).removeFromBasket(
                                product: model.product,
                              );
                        },
                      );
                    },
                    itemCount: basket.length,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '장바구니 금액',
                          style: TextStyle(
                            color: BODY_TEXT_COLOR,
                          ),
                        ),
                        Text(
                          '₩$productPrice',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '배달비',
                          style: TextStyle(
                            color: BODY_TEXT_COLOR,
                          ),
                        ),
                        if (basket.isNotEmpty)
                          Text(
                            '₩$deliveryFee',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('총액'),
                        Text(
                          '₩${productPrice + deliveryFee}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final resp = await ref
                              .read(orderProvider.notifier)
                              .postOrder();
                          if (resp) {
                            context.goNamed(OrderDoneScreen.routeName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('주문에 실패했습니다.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                        ),
                        child: Text(
                          '결제하기',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
