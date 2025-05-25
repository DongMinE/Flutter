import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/model/shopping_item_model.dart';
import 'package:riverpod_practice/riverpod/state_notifier_provider.dart';

class StateNotifierProviderScreen extends ConsumerWidget {
  const StateNotifierProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ShoppingItemModel> state = ref.watch(shoppigListProvider);

    return DefaultLayout(
      title: 'StateNotifierProvider',
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
