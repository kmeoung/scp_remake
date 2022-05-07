import 'package:flutter/material.dart';

class ReactBaseSize {
  double _standardSize = 1100;
  bool _isWebCheck() => identical(0, 0.0);
}

class ReactWrapper extends StatefulWidget {
  ReactWrapper({required this.webScaffold, required this.appScaffold});
  final WidgetBuilder webScaffold;
  final WidgetBuilder appScaffold;

  @override
  State<ReactWrapper> createState() => _ReactWrapperState();
}

class _ReactWrapperState extends State<ReactWrapper> with ReactBaseSize {
  @override
  Widget build(BuildContext context) => _render(context);
  // 여기서 뷰를 업데이트 하는 부분을 만들 수 있지 않을까?
  @override
  initState() {}

  Widget _render(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    if (_width > _standardSize) {
      return widget.webScaffold(context);
    } else {
      return widget.appScaffold(context);
    }
  }
}
