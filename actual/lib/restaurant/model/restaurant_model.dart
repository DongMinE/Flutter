import 'package:actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';
//g이름을 넣고 flutter pub run build_runner build 하면 자동으로 factory생성, nest
part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  //fromJson이 자동 생성된 값을 커스텀해야 할 때
  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });
//
  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

//   factory RestaurantModel.fromJson({
//     required Map<String, dynamic> json,
//   }) {
//     return RestaurantModel(
//       id: json['id'],
//       name: json['name'],
//       thumbUrl: 'http://$ip${json['thumbUrl']}',
//       tags: List<String>.from(json['tags']),
//       priceRange: RestaurantPriceRange.values.firstWhere(
//         (e) => e.name == json['priceRange'],
//       ),
//       ratings: json['ratings'],
//       ratingsCount: json['ratingsCount'],
//       deliveryTime: json['deliveryTime'],
//       deliveryFee: json['deliveryFee'],
//     );
//   }
}
