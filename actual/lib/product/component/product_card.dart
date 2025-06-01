import 'package:actual/common/const/colors.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;
  final String id;
  final VoidCallback? onAdd;
  final VoidCallback? onSubtract;
  //  Image.asset(
  //     'asset/img/food/ddeok_bok_gi.jpg',
  //     width: 110,
  //     height: 110,
  //     fit: BoxFit.cover,
  //   ),

  const ProductCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    required this.id,
    this.onAdd,
    this.onSubtract,
    super.key,
  });

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onAdd,
    VoidCallback? onSubtract,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      id: model.id,
      onAdd: onAdd,
      onSubtract: onSubtract,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
    VoidCallback? onAdd,
    VoidCallback? onSubtract,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      id: model.id,
      onAdd: onAdd,
      onSubtract: onSubtract,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    //IntrinsicHeight는 자식이 갖고 있는 고유 높이보다 부모의 높이를 공유한다.
    //이미지의 고유영역보다 Expanded의 높이가 낮아서 맞추기 위해 사용.
    //비용이 더 드는 위젯이기에 남발 X
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                child: image,
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      detail,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: BODY_TEXT_COLOR,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      '$price',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _Footer(
              count: basket.firstWhere((e) => e.product.id == id).count,
              total:
                  (price * basket.firstWhere((e) => e.product.id == id).count)
                      .toString(),
              onAdd: onAdd!,
              onSubstract: onSubtract!,
            ),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final int count;
  final String total;
  final VoidCallback onAdd;
  final VoidCallback onSubstract;
  const _Footer({
    required this.count,
    required this.total,
    required this.onAdd,
    required this.onSubstract,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 \$total',
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(
              icon: Icons.remove,
              onTap: onSubstract,
            ),
            const SizedBox(width: 8.0),
            Text(
              count.toString(),
              style: TextStyle(
                color: BODY_TEXT_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8.0),
            renderButton(
              icon: Icons.add,
              onTap: onAdd,
            ),
          ],
        )
      ],
    );
  }

  Widget renderButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: PRIMARY_COLOR,
        ),
      ),
      child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            color: PRIMARY_COLOR,
          )),
    );
  }
}
