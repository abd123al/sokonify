import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
import '../category/pricing_builder.dart';
import 'item_tile.dart';
import 'items_list_cubit.dart';
import 'items_stats.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PricingBuilder(
      builder: (context, list) {
        final cats = list.items;

        if (cats.isEmpty) {
          return Center(
            child: Text(
              "Please create Pricing categories.",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).errorColor,
                  ),
            ),
          );
        } else if (cats.length == 1) {
          return _build(cats[0]);
        } else {
          return DefaultTabController(
            length: cats.length,
            child: Scaffold(
              body: Column(
                children: [
                  TabBar(
                    isScrollable: false,
                    tabs: cats.map((e) => Tab(text: e.name)).toList(),
                    labelColor: Theme.of(context).primaryColorDark,
                    indicatorWeight: 4.0,
                  ),
                  Builder(
                    builder: (context) {
                      final i = DefaultTabController.of(context)?.index ?? 0;
                      print(i);
                      return Expanded(
                        child: TabBarView(
                          children: cats.map((e) => _build(cats[i])).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _build(Categories$Query$Category cat) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body:
              QueryBuilder<ResourceListData<Items$Query$Item>, ItemsListCubit>(
            retry: (cubit) => cubit.fetch(),
            builder: (context, data, _) {
              // final List<Categories$Query$Category> cats = data.items
              //     .map(
              //       (e) =>
              //           e.prices.where((element) => element.categoryId == categoryId),
              //     )
              //     .toList();

              return ListView(
                children: [
                  const InventoryStats(),
                  const SizedBox(height: 8),
                  SearchableList<Items$Query$Item>(
                    hintName: "Item",
                    data: data,
                    mainAxisSize: MainAxisSize.min,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    compare: (i) => ItemTile.formatItemName(i),
                    builder: (context, item, color) {
                      return ItemTile(
                        item: item,
                        color: color,
                      );
                    },
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => redirectTo(
              context,
              Routes.createItem,
              args: cat,
            ),
            tooltip: 'Add',
            backgroundColor: Colors.teal,
            icon: const Icon(Icons.add),
            label: const Text("Add Stock"),
          ),
        );
      },
    );
  }
}
