import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
/*
 dio와 retrofit의 header 중 뭐를 사용할지 모름, dio의 header를 사용하지 않겠다.
 import 'package:dio/dio.dart' as dio;
 import 'package:retrofit/retrofit.dart' as ret;
 hide 하지 않고 위의 dio.~으로 사용해서도 가능
*/
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

// g파일이 생성될 때 errorLogger가 에러가 나는 이유는 import기반으로 생성될 때 필요한
// import가 없어서 발생하므로 "import 'package:retrofit/retrofit.dart';" 추가
part 'restaurant_repository.g.dart';

@RestApi()
//RestApi는 retrofit 인터페이스임을 알리며 g.dart 코드가 생성되는 트리거
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  //레스토랑 리스트
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  // cursor_pagination_model에서 선언한 CursorPagination의 data타입을 명시하면
  // T가 자동으로 RestaurantDetailModel으로 변환
  Future<CursorPagination<RestaurantModel>> paginate();

  // id의 제품 목록
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  //GET안에 들어가는 파라미터와 required의 값이 다를 때는
  // Path(id) required String sid 식으로 넣기
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
