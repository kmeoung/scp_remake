import 'package:flutter/material.dart';

class ReactBaseSize {
  double _standardSize = 1100;
  bool _isWebCheck() => identical(0, 0.0);
}

class ReactWrapper extends StatelessWidget with ReactBaseSize {
  final WidgetBuilder webScaffold;
  final WidgetBuilder appScaffold;

  ReactWrapper({required this.webScaffold, required this.appScaffold});

  @override
  Widget build(BuildContext context) => _render(context);

  Widget _render(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    if (_width > _standardSize) {
      return webScaffold(context);
    } else {
      return appScaffold(context);
    }
  }
}
