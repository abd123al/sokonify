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
          return Tabbed(
            builder: (context, cat) => _build(cat),
            categories: cats,
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
              List<Items$Query$Item> cats = [];

              for (var e in data.items) {
                if (e.prices.map((e) => e.categoryId).contains(cat.id)) {
                  cats.add(e);
                }
              }

              return ListView(
                children: [
                  if (cats.isNotEmpty)
                    InventoryStats(
                      category: cat,
                    ),
                  const SizedBox(height: 8),
                  SearchableList<Items$Query$Item>(
                    hintName: "Item",
                    data: data.copyWith(
                      items: cats,
                    ),
                    mainAxisSize: MainAxisSize.min,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    compare: (i) => ItemTile.formatItemName(i),
                    builder: (context, item, color) {
                      return ItemTile(
                        item: item,
                        color: color,
                        pricingId: cat.id,
                      );
                    },
                  ),
                ],
              );
            },
          ),
          floatingActionButton: PermissionBuilder(
            type: PermissionType.addStock,
            builder: (context) {
              return FloatingActionButton.extended(
                onPressed: () => redirectTo(
                  context,
                  Routes.createItem,
                  args: cat,
                ),
                tooltip: 'Add',
                icon: const Icon(Icons.add),
                label: const Text("Add Stock"),
              );
            },
          ),
        );
      },
    );
  }
}

class Tabbed extends StatefulWidget {
  const Tabbed({
    Key? key,
    required this.builder,
    required this.categories,
  }) : super(key: key);

  final Widget Function(
    BuildContext context,
    Categories$Query$Category,
  ) builder;
  final List<Categories$Query$Category> categories;

  @override
  State<StatefulWidget> createState() {
    return _TabbedState();
  }
}

class _TabbedState extends State<Tabbed> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = widget.categories.map((e) => Tab(text: e.name)).toList();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: tabs,
          labelColor: Theme.of(context).primaryColorDark,
          indicatorWeight: 4.0,
        ),
        Builder(
          builder: (context) {
            return Expanded(
              child: TabBarView(
                controller: _tabController,
                children: widget.categories
                    .map((e) => widget.builder(context, e))
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
