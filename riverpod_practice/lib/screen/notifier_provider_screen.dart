import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/layout/default_layout.dart';
import 'package:riverpod_practice/model/shopping_item_model.dart';
import 'package:riverpod_practice/riverpod/notifier_provider.dart';

class NotifierProviderScreen extends ConsumerWidget {
  const NotifierProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ShoppingItemModel> state = ref.watch(shoppingListProvider2);

    return DefaultLayout(
      title: 'NotifierProvider',
      body: ListView(
        children: state
            .map(
              (e) => CheckboxListTile(
                title: Text(e.name),
                value: e.hasBougth,
                // shoppngListProvider에 만들어둔 toggleHasBougth
                onChanged: (value) {
                  ref
                      .read(shoppingListProvider2.notifier)
                      .toggleHasBougth(name: e.name);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
