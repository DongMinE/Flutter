import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/riverpod/select_provider.dart';

class SelectProviderScreen extends ConsumerWidget {
  const SelectProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectProvider.select((value) => value.isSpicy));
    ref.listen(selectProvider.select((value) => value.hasBougth),
        (previous, next) {
      print('next: $next');
    });

    return DefaultLayout(
      title: 'SelectProviderScreen',
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // isSpicy가 바뀔 때만 리빌드하라고 변경
            Text(state.toString()),
            // Text(
            //   state.name,
            // ),
            // Text(
            //   state.isSpicy.toString(),
            // ),
            // Text(
            //   state.hasBougth.toString(),
            // ),
            ElevatedButton(
              onPressed: () {
                ref.read(selectProvider.notifier).toggleIsSpicy();
              },
              child: Text(
                '맵기 변경',
              ),
            ),
            // 구매 변경을 해도 값은 바뀌지만 리빌드 되지않아 반영 안됨
            // listen을 추가하면 구매여부가 변경될 때만 값이 바뀌도록
            ElevatedButton(
              onPressed: () {
                ref.read(selectProvider.notifier).toggleHasBougth();
              },
              child: Text(
                '구매 변경',
              ),
            )
          ],
        ),
      ),
    );
  }
}
