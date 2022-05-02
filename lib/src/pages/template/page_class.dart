import 'package:flutter/material.dart';
import 'package:refactory_scp/src/pages/template/react_wrapper.dart';

abstract class PageClass extends StatelessWidget {
  const PageClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _render();

  Widget _render() =>
      ReactWrapper(webScaffold: webScaffold, appScaffold: appScaffold);

  void initSetting(BuildContext context);
  Widget webScaffold(BuildContext context);
  Widget appScaffold(BuildContext context);
}
