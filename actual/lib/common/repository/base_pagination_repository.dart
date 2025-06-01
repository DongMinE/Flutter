// 인터페이스라는 키워드는 없지만 abstract를 사용해 대체 => 3.0부터 생김

import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  // cursor_pagination_model에서 선언한 CursorPagination의 data타입을 명시하면
  // T가 자동으로 RestaurantDetailModel으로 변환
  // 다른 레포지토리에서 paginate를 구현
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
