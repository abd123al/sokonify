import 'package:blocitory/helpers/resource_query_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/widgets/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/stats_repository.dart';
import '../../pdf/sales_list.dart';
import 'sales_cubit.dart';

class PrintSalesPage extends StatelessWidget {
  const PrintSalesPage({
    Key? key,
    required this.args,
    required this.word,
  }) : super(key: key);

  final StatsArgs args;
  final String word;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Print $word Sales"),
      ),
      body: PermissionBuilder(
        type: PermissionType.viewStats,
        builder: (context) {
          return _body();
        },
      ),
    );
  }

  Widget _body() {
    return BlocProvider(
      create: (context) {
        return SalesCubit(RepositoryProvider.of<StatsRepository>(context));
      },
      child: QueryBuilder<List<Sales$Query$OrderItem>, SalesCubit>(
        retry: (cubit) => cubit.fetch(args),
        initializer: (cubit) => cubit.fetch(args),
        builder: (context, data, _) {
          return StoreBuilder(
            noBuilder: (context) => const SizedBox(),
            builder: (context, store) {
              return PdfPreview(
                canDebug: kDebugMode,
                pdfFileName: "${word.replaceAll(" ", "_")}.pdf",
                initialPageFormat: PdfPageFormat.a4,
                build: (PdfPageFormat format) {
                  return generateSalesList(
                    format,
                    data,
                    store,
                    word,
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
