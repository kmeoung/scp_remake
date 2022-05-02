import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refactory_scp/provider/home_controller.dart';
import 'package:refactory_scp/src/pages/home/home_page.dart';

import '../common/colors.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  String _userId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.deepPurple,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'SCP ',
                  style: TextStyle(
                      color: CustomColors.yellow,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Project ',
                  style: TextStyle(
                      color: CustomColors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: CustomColors.white,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      _userId = text;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Insert User id',
                      hintStyle: TextStyle(
                          color: CustomColors.deepPurple.withOpacity(0.5)),
                      label: null,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: CustomColors.yellow,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HomePage(
                        uid: _userId,
                      ),
                    ),
                  );
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 17),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
