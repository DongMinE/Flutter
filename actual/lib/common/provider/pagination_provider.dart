import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _PaginationInfo {
  final int fetchCount;
  //true = 추가로 가져옴
  //false = 새로고침(현재상태 덮어 씌움)
  final bool fetchMore;
  //강제 리로딩
  //ture = CursorPaginationLoading()
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

/* 
  레스토랑프로바이더와 레이팅프로바이더처럼 하위동작이 모두 같도록 
  설계했다면 oop를 따라 레스토랑프로바이더에 작성했던 paginate를 그대로 가져옴
*/
class PaginationProvider<
//실제 데이터 타입은 ID를 무조건 갖는 타입
        T extends IModelWithId,
//실제 레포지토리는 paginate()를 무조건 갖는 레포지토리
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  final paginationThrottle = Throttle(
    Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();

    paginationThrottle.values.listen(
      (state) {
        _throttlePagination(state);
      },
    );
  }

  Future<void> paginate({
    int fetchCount = 20,
    //true = 추가로 가져옴
    //false = 새로고침(현재상태 덮어 씌움)
    bool fetchMore = false,
    //강제 리로딩
    //ture = CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(_PaginationInfo(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
    ));
  }

  _throttlePagination(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;

    try {
      //페이지네이션 전(1페이지만 부름)
      // resp는 이미 CursorPagination<RestaurantModel>로 페이지네이션이 된 데이터
      // final resp = await repository.paginate();
      // state = resp;

      //페이지네이션 후

      // 바로 반환하는 상황
      // 1) hasMore = false => 다음 데이터가 존재하지않음, CursorPaginationMeta에 있음
      // state는 StateNotifier에서 관리하고 있는 값
      // 한번 값을 불러왔고 강제새로고침하는 상태가 아니라면 pState는 무조건 CursorPagination
      if (state is CursorPagination && !forceRefetch) {
        //캐스팅을 해줘야 자동완성을 제공 / 안하면 어떤 상태인지 코드는 모름
        final pState = state as CursorPagination;
        // 더이상 데이터가 없다
        if (!pState.meta.hasMore) {
          return;
        }
      }
      // 2) 로딩중 - fatchMore: true
      //    fetchMore 가 아닐때 - 새로고침의 의도가 있을 수 있다.
      final isLoading = state is CursorPaginationLoading;
      final isFetching = state is CursorpaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;
      if (fetchMore && (isLoading || isFetching || isFetchingMore)) {
        return;
      }

      //5가지 가능성의 데이터
      // 1) CursorPagination = 정상데이터 있음
      // 2) CursorPaginationLoading = 데이터 로딩중(현재 캐시 없음)
      // 3) CursorPaginationError = 에러
      // 4) CursorPaginationRefetching = 첫 페이지부터 다시
      // 5) CursorPaginationFetchMore = 추가 페이지 요청

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore
      // 데이터를 추가로 요청하는 상황
      if (fetchMore) {
        //기존 데이터가 있다고 확신함, 캐스팅 해야 data 꺼내올 수 있음
        final pState = state as CursorPagination<T>;
        //상태를 FetchingMore로 바꿈(로딩중)
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );
        //params의 가장 끝 id를 교체함
        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      //데이터를 처음부터 가져오는 상황
      else {
        //만약 데이터가 있는 상황이라면
        //기존 데이터를 보존한 채로 Fetch(api 요청)을 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorpaginationRefetching<T>(
            data: pState.data,
            meta: pState.meta,
          );
          //나머지 상황
        } else {
          state = CursorPaginationLoading();
        }
      }

      //교체된 params로 데이터 추가 요청
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );
      //상태가 FetchingMore라면
      if (state is CursorPaginationFetchingMore) {
        //CursorPagination이었던 pState를 CursorPaginationFetchingMore로 캐스팅
        final pState = state as CursorPaginationFetchingMore<T>;

        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
