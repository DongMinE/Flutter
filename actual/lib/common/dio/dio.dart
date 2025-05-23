import 'package:actual/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1)요청
  // 요청이 들어올 때마다
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    // accessToken
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }
    // refreshToken
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2)응답
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    super.onResponse(response, handler);
  }

  // 3)에러
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    //401에러
    //토큰 재발후 다시 재요청
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    //refreshToken이 아예 없으면 에러발생
    if (refreshToken == null) {
      //에러 발생은 reject 사용
      return handler.reject(err);
    }
    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    //응답이 401(토큰 만료)인데 재발급요청 api가 아닌경우
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      //엑세스 토큰 재발급 시도
      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );
        //엑세스 토큰 재발급 성공
        final accessToken = resp.data['accessToken'];
        //기존요청의 헤더에 새로운 토큰 수정
        final options = err.requestOptions;
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });
        //엑세스 토큰을 새로 받은 토큰으로 덮어쓰기
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        //기존 요청을 재요청
        final response = await dio.fetch(options);
        //에러로 왔지만 성공된 요청으로 클라이언트에 응답
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
