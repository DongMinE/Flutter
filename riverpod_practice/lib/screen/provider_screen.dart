import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/riverpod/provider.dart';
import 'package:riverpod_practice/riverpod/state_notifier_provider.dart';

class ProviderScreen extends ConsumerWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref하고 있는 것은 filterShoppngListPrivider인데
    // 그 안의 shoppngListProvider를 변경해도 state가 바뀜
    // 맵기 정보 탭 변경에 따라 리스트가 변경
    final state = ref.watch(filterShoppngListProvider);

    return DefaultLayout(
      title: "ProviderScreen",
      actions: [
        PopupMenuButton<FilterState>(
          itemBuilder: (_) => FilterState.values
              .map(
                (e) => PopupMenuItem(
                  value: e,
                  child: Text(e.name),
                ),
              )
              .toList(),
          onSelected: (value) => ref.read(filterProvider.notifier).update(
                (state) => value,
              ),
        ),
      ],
      body: ListView(
        children: state
            .map(
              (e) => CheckboxListTile(
                title: Text(e.name),
                value: e.hasBougth,
                // shoppngListProvider에 만들어둔 toggleHasBougth
                onChanged: (value) {
                  ref
                      .read(shoppigListProvider.notifier)
                      .toggleHasBougth(name: e.name);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
