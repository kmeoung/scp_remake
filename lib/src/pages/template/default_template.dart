import 'package:flutter/material.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/components/navigation_menu.dart';
import 'package:refactory_scp/src/components/right_menu.dart';
import 'package:refactory_scp/src/pages/template/page_class.dart';

/// View Template
abstract class DefaultTemplate extends PageClass {
  final String _userId;
  bool isMobile = false;

  DefaultTemplate(this._userId, {Key? key}) : super(key: key);

  /// Page Scaffold State
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget appScaffold(BuildContext context) {
    return _commomWidget(context, isMobile: true);
  }

  @override
  void initSetting(BuildContext context);

  @override
  Widget webScaffold(BuildContext context) {
    return _commomWidget(context, isMobile: false);
  }

  Widget _commomWidget(BuildContext context, {required bool isMobile}) {
    this.isMobile = isMobile;
    return Scaffold(
      backgroundColor: CustomColors.white,
      key: _key,
      floatingActionButton: floatingActionButton(context),
      endDrawer: isMobile
          ? Container(
              width: MediaQuery.of(context).size.width * 0.6,
              color: CustomColors.deepPurple,
              child: RightMenu(_userId),
            )
          : null,
      body: Container(
        alignment: Alignment.topCenter,
        color: CustomColors.whitePurple,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isMobile
                ? NavigationMenu(
                    scaffoldKey: _key,
                  )
                : Container(),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1680),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: isMobile
                            ? _mobileLayout(context)
                            : _desktopLayout(context),
                      ),
                    ),
                    !isMobile
                        ? RightMenu(
                            _userId,
                            width: 300,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final ScrollController mainScrollController = ScrollController();

  FloatingActionButton? floatingActionButton(BuildContext context);

  /// View Custom Detail
  Widget customDetail(ScrollController scrollController, BuildContext context);

  /// Page Scaffold State
  Widget _contentsDetail(BuildContext context) {
    return customDetail(mainScrollController, context);
  }

  Widget _mobileLayout(BuildContext context) {
    return _contentsDetail(context);
  }

  Widget _desktopLayout(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      controller: mainScrollController,
      child: _contentsDetail(context),
    );
  }
}
