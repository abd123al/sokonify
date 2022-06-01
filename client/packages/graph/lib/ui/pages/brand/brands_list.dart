import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/widgets.dart';
import 'brand_tile.dart';
import 'brands_list_cubit.dart';

class BrandsList extends StatelessWidget {
  const BrandsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Brands$Query$Brand>, BrandsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return SearchableList<Brands$Query$Brand>(
          hintName: "Brand",
          data: data,
          compare: (i) => i.name,
          builder: (context, item, color) {
            return BrandTile(
              expense: item,
              color: color,
            );
          },
        );
      },
    );
  }
}
