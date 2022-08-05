import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/searchable_dropdown.dart';
import '../category/categories_wrapper.dart';

class StaffPricingForm extends StatefulWidget {
  const StaffPricingForm({
    Key? key,
    required this.id,
    required this.pricingIds,
  }) : super(key: key);

  final int id;
  final List<int> pricingIds;

  @override
  State<StatefulWidget> createState() {
    return _CreateProductPageState();
  }
}

class _CreateProductPageState extends State<StaffPricingForm> {
  late List<int> _pricingIds;

  @override
  void initState() {
    super.initState();
    _pricingIds = widget.pricingIds;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            CategoriesWrapper(
              type: CategoryType.pricing,
              builder: (context, list) {
                return SearchableDropdown<
                    Categories$Query$Category>.multiSelection(
                  asString: (i) => i.name,
                  data: list,
                  labelText: "Pricing Categories",
                  builder: (context, e) {
                    return ListTile(
                      title: Text(e.name),
                    );
                  },
                  hintText: "Pricing",
                  helperText:
                      "Select pricing categories which staff will have access to",
                  onChangedMultiSelection: (item) => setState(() {
                    _pricingIds = item.map((e) => e.id).toList();
                  }),
                  selectedItems: list.items
                      .where((e) => _pricingIds.contains(e.id))
                      .toList(),
                );
              },
            ),
            const SizedBox(
              height: 8,
            ),
            // MutationBuilder<CreateProduct$Mutation$Product, CreateProductCubit,
            //     ProductRepository>(
            //   blocCreator: (r) => CreateProductCubit(r),
            //   pop: true,
            //   builder: (context, cubit) {
            //     return Button(
            //       padding: EdgeInsets.zero,
            //       callback: () {
            //         final input = ProductInput(
            //           categories: _permissions.map((e) => e.id).toList(),
            //         );
            //
            //         if (isEdit) {
            //           cubit.edit(widget.id!, input);
            //         } else {
            //           cubit.create(input);
            //         }
            //       },
            //       title: 'Submit',
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
