import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

//restaurantProvider를 통해 가져온 리스트 중 id에 맞는 값만 꺼내옴
final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }
  // firstWhere는 null일때 오류 발생해서 orNull 사용
  return state.data.firstWhereOrNull((element) => element.id == id);
});

//전체 restaurantProvider 리스트
//RestaurantStateNotifier의 상태를 관리하며 타입은 CursorPaginationBase
final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

// class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
// @override
// List<RestaurantModel> build() {
// final RestaurantRepository repository;
//   return [];
// }

//CursorPaginationBase는 여러 모델을 상속받은 부모이기 때문에 CursorPaginationLoading 가능
class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 데이터가 없는 상태 (CursorPagination이 아님)
    // 데이터 가져오는 시도
    if (state is! CursorPagination) {
      await this.paginate();
    }

    // state가 CursorPagination이 아닐 때 그냥 리턴
    if (state is! CursorPagination) {
      return;
    }
    // 전체 리스트
    final pState = state as CursorPagination;
    // 세부 데이터
    final resp = await repository.getRestaurantDetail(id: id);

    // 전체 리스트 중 요청id만 상세정보가 담긴 값으로 변경
    // 만약 음식탭을 내려서 기존의 레스토랑 모델ID가 없는 음식의 ID 클릭시 해당 레스토랑은 없음
    // 이를 위한 처리가 필요함
    // id에 해당 레스토랑모델이 있으면 resp를 삽입하고 없으면 그대로 끝에 붙임
    // 이를 통해 id가 없을 때 프로바이더는 null을 반환하고 로딩바가 뜨며
    // 상세페이지에서 getDetail을 호출 시 데이터가 있는 상태로 변경됨
    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp,
        ],
      );
    } else {
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? resp : e)
            .toList(),
      );
    }
  }
}
