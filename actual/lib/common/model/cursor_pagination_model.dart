import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

// T타입의 제너릭을 넣기 위해서는 genericArgumentFactories필요
// T타입으로 받는 이유는 data가 레스토랑,주문,제품 등 여러타입이 존재
// 이렇게 제너릭으로 통일하면 페이징이 필요한 화면을 하나의 함수로 통일
@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

// fromJsonT 인자를 추가
// g파일은 List<dynamic>형태의 json을 toList하는 것을 자동생성
  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}
