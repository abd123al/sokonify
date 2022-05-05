import 'package:flutter/material.dart';

import '../utils/application.dart';

redirectTo(
  BuildContext context,
  String route, {
  Object? args,
  bool replace = false,
}) {
  Application.router?.navigateTo(
    context,
    route,
    replace: replace,
    routeSettings: RouteSettings(
      arguments: args,
    ),
  );
}
