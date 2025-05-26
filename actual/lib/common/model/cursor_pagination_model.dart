import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

/*
  레포지토리의 반환값이 페이지네이션을 위한 corsorPagination을 받아야하는데  
  cursorPagination<모델>로 받고 있어서 페이징이 불가능한 상태
  중요한 것은 CirsorPaginamtionBase를 상속한 CursorPagination<T>가
  CirsorPaginamtionBase의 같은 타입이냐? 가 true이다.
*/
abstract class CursorPaginationBase {}

//에러
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

//로딩1 - 데이터가 없을 때 요청
class CursorPaginationLoading extends CursorPaginationBase {}

/* 
  T타입의 제너릭을 넣기 위해서는 genericArgumentFactories필요
  T타입으로 받는 이유는 data가 레스토랑,주문,제품 등 여러타입이 존재
  이렇게 제너릭으로 통일하면 페이징이 필요한 화면을 하나의 함수로 통일 
*/
@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

/* 
  fromJsonT 인자를 추가
  g파일은 List<dynamic>형태의 json을 toList하는 것을 자동생성 
*/
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

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

//로딩2 - 데이터가 있고 새로고침을 할 때
class CursorpaginationRefetching<T> extends CursorPagination<T> {
  CursorpaginationRefetching({
    required super.data,
    required super.meta,
  });
}

//로딩3 - 리스트를 최하단에서 더 데이터를 요청
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
