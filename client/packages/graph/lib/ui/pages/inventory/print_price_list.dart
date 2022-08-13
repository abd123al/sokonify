import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../pdf/price_list.dart';
import '../../widgets/searchable_dropdown.dart';
import '../../widgets/store_builder.dart';
import '../category/pricing_builder.dart';
import 'pricing_items_wrapper.dart';

class PrintPriceListPage extends StatefulWidget {
  const PrintPriceListPage({
    Key? key,
    required this.pricingId,
  }) : super(key: key);

  final int pricingId;

  @override
  State<StatefulWidget> createState() {
    return _PrintPriceListPageState();
  }
}

class _PrintPriceListPageState extends State<PrintPriceListPage> {
  int? _pricingId;
  String _title = "";

  @override
  void initState() {
    super.initState();
    _pricingId = widget.pricingId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_title Prices"),
      ),
      body: Column(
        children: [
          PricingBuilder(
            builder: (context, cats) {
              if (_pricingId == null) {
                return SearchableDropdown<Categories$Query$Category>(
                  asString: (i) => i.name,
                  data: cats,
                  labelText: "Select Pricing",
                  hintText: "Type pricing name",
                  helperText:
                      "Prices will be printed based on pricing category.",
                  selectedItem: (e) => e.id == _pricingId,
                  onChanged: (p) => setState(() {
                    _pricingId = p?.id;
                    _title = p?.name ?? "";
                  }),
                );
              }

              return const SizedBox();
            },
          ),
          Expanded(
            child: StoreBuilder(
              noBuilder: (BuildContext ctx) {
                return const SizedBox();
              },
              builder: (context, store) {
                if (_pricingId == null) {
                  return const SizedBox.shrink();
                }

                return PricingItemsWrapper(
                  pricingId: _pricingId!,
                  builder: (context, items) {
                    return PdfPreview(
                      canDebug: kDebugMode,
                      pdfFileName: "${_title}_prices.pdf",
                      initialPageFormat: PdfPageFormat.a4,
                      build: (PdfPageFormat format) {
                        return generatePriceList(
                          format,
                          items.items,
                          store,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
