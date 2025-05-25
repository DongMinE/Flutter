import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_generation_provider.g.dart';

// riverpod에 codeGeneration을 사용/필요한 이유.
// 1) 어떤 Provider를 사용할지 고민할 필요 없음

final _testProvider = Provider<String>(
  (ref) => 'Hello Code Generation',
);

// 제너레이터를 통해 자동생성된 함수는 '이름+Provider'로 생성됨
@riverpod
String gState(Ref ref) {
  return 'Hello Code Generation';
}

@riverpod
Future<int> gStateFuture(Ref ref) async {
  await Future.delayed(Duration(seconds: 3));

  return 10;
}

@Riverpod(
  keepAlive: true,
)
Future<int> gStateFuture2(Ref ref) async {
  await Future.delayed(Duration(seconds: 3));

  return 10;
}

// 2) Parameter가 여러개일 때 Family 파라미터로 일반함수첨 사용할 수 있도록
//   2-1) family에 data 인자는 한개만 가능한데 여러개일 때 클래스 생성해야하는 불편
class Parameter {
  final int num1;
  final int num2;

  Parameter({
    required this.num1,
    required this.num2,
  });
}

final _testFamilyProvider = Provider.family<int, Parameter>(
  (ref, param) => param.num1 * param.num2,
);

@riverpod
int gStateMultiply(
  Ref ref, {
  required int num1,
  required int num2,
}) {
  return num1 * num2;
}

//stateNotifierProvider 코드제너레이션
@riverpod
class GNotifier extends _$GNotifier {
  @override
  int build() {
    return 10;
  }

  increament() {
    state++;
  }

  decreament() {
    state--;
  }
}
