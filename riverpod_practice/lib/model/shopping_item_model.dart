class ShoppingItemModel {
  final String name;
  final int quantity;
  final bool hasBougth;
  final bool isSpicy;

  ShoppingItemModel({
    required this.name,
    required this.quantity,
    required this.hasBougth,
    required this.isSpicy,
  });

  //특정 값만 바꾸고 싶을 때 값으로 넘기지 않은 값은 원래 값을 갖고 있기
  ShoppingItemModel copyWith({
    String? name,
    int? quantity,
    bool? hasBougth,
    bool? isSpicy,
  }) {
    return ShoppingItemModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      hasBougth: hasBougth ?? this.hasBougth,
      isSpicy: isSpicy ?? this.isSpicy,
    );
  }
}
