import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';
import '../../widgets/widgets.dart';
import 'convert_stocks_cubit.dart';
import 'items_wrapper.dart';

class ConvertStockPage extends StatefulWidget {
  const ConvertStockPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ConvertStockPageState();
  }
}

class _ConvertStockPageState extends State<ConvertStockPage> {
  Items$Query$Item? _from;
  Items$Query$Item? _to;
  int? _quantity, _formula;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convert Stock"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ItemsWrapper(
              builder: (context, list) {
                formatName(Items$Query$Item i) {
                  return "${i.unit.name} - ${i.product.name}";
                }

                tile(Items$Query$Item i) {
                  return ListTile(
                    title: Text(formatName(i)),
                    subtitle: Text("${i.quantity} ${i.unit.name}"),
                  );
                }

                return FormList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SearchableDropdown<Items$Query$Item>(
                      asString: (i) => formatName(i),
                      data: list,
                      labelText: "Enter item name to convert from",
                      hintText: "Type product name",
                      helperText: "Quantity will be reduced for this stock",
                      selectedItem: (e) => e == _from,
                      isOptional: false,
                      builder: (_, i) => tile(i),
                      onChanged: (item) => setState(() {
                        _from = item;
                      }),
                    ),
                    TextFormField(
                      onChanged: (v) {
                        setState(() {
                          _quantity = int.tryParse(v);
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Quantity to convert',
                        hintText: 'Enter quantity you wish to convert',
                        helperText: 'Specify quantity you wish to convert',
                        suffixText: _from?.unit.name ?? "",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "0") {
                          return 'Please valid enter quantity..';
                        }

                        if (_from == null) {
                          return "The above field is empty";
                        }

                        if (int.parse(value) > _from!.quantity) {
                          return "The specified quantity is greater than available quantity.";
                        }

                        return null;
                      },
                    ),
                    Container(
                      height: 8,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    SearchableDropdown<Items$Query$Item>(
                      asString: (i) => formatName(i),
                      data: list,
                      labelText: "Enter item name to convert to",
                      hintText: "Type product name",
                      helperText: "Quantity will be increased for this stock",
                      selectedItem: (e) => e == _to,
                      builder: (_, i) => tile(i),
                      validator: (v) {
                        if (v == null) {
                          return "This field is required.";
                        }

                        if (v.product.id != _from?.product.id) {
                          return "You can't convert stocks of different products.";
                        }

                        return null;
                      },
                      onChanged: (item) => setState(() {
                        _to = item;
                      }),
                    ),
                    Container(
                      height: 8,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    TextFormField(
                      onChanged: (v) {
                        setState(() {
                          _formula = int.tryParse(v);
                        });
                      },
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Conversion Formula',
                        hintText: '?',
                        helperText: 'Example 1 Dozen = 12 Pieces.',
                        prefixText: "1 ${_from?.unit.name} = ",
                        suffixText: _to?.unit.name ?? "",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "0") {
                          return 'Please specify formula';
                        }

                        if (_from == null) {
                          return "The above field is empty";
                        }

                        if (int.parse(value) > _to!.quantity) {
                          return "The specified quantity is greater than available quantity.";
                        }

                        return null;
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final f = _formula ?? 0;
                        final q = _quantity ?? 0;

                        final total = f * q;

                        if (total == 0) return const SizedBox.shrink();

                        return Card(
                          color: Theme.of(context).secondaryHeaderColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "$_quantity "
                              "${_from?.unit.name ?? ""} of "
                              "${_from?.product.name} "
                              "will be converted to "
                              "$total "
                              "${_to?.unit.name ?? ""} of "
                              "${_to?.product.name}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            MutationBuilder<List<ConvertStock$Mutation$Item>,
                ConvertStocksCubit, ItemRepository>(
              blocCreator: (r) => ConvertStocksCubit(r),
              onSuccess: (context, data) {},
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: const EdgeInsets.all(8.0),
                  callback: () {
                    if (_formKey.currentState!.validate()) {
                      final input = ConvertStockInput(
                        eachEqualsTo: _formula!,
                        quantity: _quantity!,
                        from: _from!.id,
                        to: _to!.id,
                      );

                      cubit.submit(input);
                    }
                  },
                  title: 'Convert',
                );
              },
            ),
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
