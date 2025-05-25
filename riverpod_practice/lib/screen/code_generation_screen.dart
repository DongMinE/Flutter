import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/riverpod/code_generation_provider.dart';

class CodeGenerationScreen extends ConsumerWidget {
  const CodeGenerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state1 = ref.watch(gStateProvider);
    final state2 = ref.watch(gStateFutureProvider);
    final state3 = ref.watch(gStateFuture2Provider);
    final state4 = ref.watch(gStateMultiplyProvider(
      num1: 1,
      num2: 10,
    ));
    // _StateFiveWidget로 만든 state5는 리빌드 되지 않음
    // 상위에서 watch하고 있지 않음
    // final state5 = ref.watch(gNotifierProvider);

    print('build');

    return DefaultLayout(
      title: 'CodeGenerationScreen',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('State1: $state1'),
          state2.when(
            data: (data) {
              return Text(
                data.toString(),
                textAlign: TextAlign.center,
              );
            },
            error: (err, stack) => Text(
              err.toString(),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
          state3.when(
            data: (data) {
              return Text(
                data.toString(),
                textAlign: TextAlign.center,
              );
            },
            error: (err, stack) => Text(
              err.toString(),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
          Text('state4: $state4'),
          // Text('state5: $state5'),
          // _StateFiveWidget(),
          // 리빌드 하기 싫은 특정값만 상태관리 하기 위한 riverpod 기능
          Consumer(
            builder: (context, ref, child) {
              final state5 = ref.watch(gNotifierProvider);
              return Row(
                children: [
                  Text('State5: $state5'),
                  // 아래 작성한 child가 빌더에 제공됨
                  // 빌더 안에 넣고 싶지만 state5만 렌더링하고 싶은 위젯은 child에
                  child!,
                ],
              );
            },
            child: Text('Hello'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(gNotifierProvider.notifier).increament();
                },
                child: Text('증가'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(gNotifierProvider.notifier).decreament();
                },
                child: Text('감소'),
              ),
            ],
          ),
          // invalidate() 란?
          // 유효하지 않다 => 캐싱을 무효화하고 리빌드하여 초기상태로 돌아감
          ElevatedButton(
            onPressed: () {
              ref.invalidate(gNotifierProvider);
            },
            child: Text('Invalidate'),
          ),
        ],
      ),
    );
  }
}

// 하위로 위젯을 생성하여 사용하는 값은 리빌드 되지 않음
// 간단한 코드임에도 위젯을 일일이 만든다? 불편함 => Consumer로 만듬
class _StateFiveWidget extends ConsumerWidget {
  const _StateFiveWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state5 = ref.watch(gNotifierProvider);

    return Text('State5: $state5');
  }
}
