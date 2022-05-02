import 'package:flutter/material.dart';
import 'package:refactory_scp/src/common/colors.dart';

/// Mobile Layout 시 상단에 뜨는 Navigation Menu
class NavigationMenu extends StatelessWidget {
  /// Page Scaffold State
  final GlobalKey<ScaffoldState>? _key;

  NavigationMenu({Key? key, GlobalKey<ScaffoldState>? scaffoldKey})
      : _key = scaffoldKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.deepPurple,
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  'SCP ',
                  style: TextStyle(
                      color: CustomColors.yellow,
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Project ',
                  style: TextStyle(
                      color: CustomColors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // Drawer 열기
              _key?.currentState?.openEndDrawer();
            },
            child: const SizedBox(
              width: 80,
              height: 80,
              child: Icon(
                Icons.menu,
                color: CustomColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
