import 'package:blocitory/helpers/resource_query_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/widgets/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/stats_repository.dart';
import '../../pdf/daily_stats.dart';
import 'daily_stats_cubit.dart';

class PrintDailyStatsPage extends StatelessWidget {
  const PrintDailyStatsPage({
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
        title: const Text("Print Stats"),
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
        return DailyStatsCubit(RepositoryProvider.of<StatsRepository>(context));
      },
      child: QueryBuilder<DailyStats$Query, DailyStatsCubit>(
        retry: (cubit) => cubit.fetch(args),
        initializer: (cubit) => cubit.fetch(args),
        builder: (context, data, _) {
          return StoreBuilder(
            noBuilder: (context) => const SizedBox(),
            builder: (context, store) {
              return PdfPreview(
                canDebug: kDebugMode,
                pdfFileName: "daily_stats.pdf",
                initialPageFormat: PdfPageFormat.a4,
                build: (PdfPageFormat format) {
                  return generateDailyStats(
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
