import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../pdf/price_list.dart';
import '../../widgets/searchable_dropdown.dart';
import '../../widgets/store_builder.dart';
import '../category/pricing_builder.dart';
import 'items_list_cubit.dart';
import 'pricing_items_wrapper.dart';

class PrintPriceListPage extends StatefulWidget {
  const PrintPriceListPage({
    Key? key,
    required this.pricing,
    this.inventory = false,
  }) : super(key: key);

  final Categories$Query$Category pricing;
  final bool inventory;

  @override
  State<StatefulWidget> createState() {
    return _PrintPriceListPageState();
  }
}

class _PrintPriceListPageState extends State<PrintPriceListPage> {
  Categories$Query$Category? _pricing;

  @override
  void initState() {
    super.initState();
    _pricing = widget.pricing;
  }

  @override
  Widget build(BuildContext context) {
    //We need updated prices
    BlocProvider.of<ItemsListCubit>(context).fetch();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${_pricing?.name ?? ""} ${widget.inventory ? "Inventory" : "Prices"}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      child: PricingBuilder(
                        builder: (context, cats) {
                          return SearchableDropdown<Categories$Query$Category>(
                            asString: (i) => i.name,
                            searchAutofocus: false,
                            data: cats,
                            labelText: "Select Pricing",
                            hintText: "Type pricing name",
                            helperText:
                                "Prices will be printed based on pricing category.",
                            selectedItem: (e) => e.id == _pricing?.id,
                            onChanged: (p) => setState(() {
                              _pricing = p;

                              Navigator.pop(context);
                            }),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: StoreBuilder(
        noBuilder: (BuildContext ctx) {
          return const SizedBox();
        },
        builder: (context, store) {
          if (_pricing == null) {
            return const SizedBox.shrink();
          }

          return PricingItemsWrapper(
            pricingId: _pricing!.id,
            builder: (context, items) {
              return PdfPreview(
                canDebug: kDebugMode,
                pdfFileName:
                    "${_pricing!.name}${widget.inventory ? "_inventory" : "_prices"}.pdf",
                initialPageFormat: PdfPageFormat.a4,
                build: (PdfPageFormat format) {
                  return generatePriceList(
                    format,
                    items.items,
                    store,
                    _pricing!,
                    widget.inventory,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
