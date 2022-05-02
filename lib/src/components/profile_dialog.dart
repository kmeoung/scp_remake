import 'package:flutter/material.dart';
import 'package:refactory_scp/src/common/colors.dart';

import 'content_title.dart';

/// 프로필 확인, 변경 Dialog
class ProfileDialog extends StatelessWidget {
  double width;
  double height;
  bool isDesktop;
  ProfileDialog({
    Key? key,
    required this.width,
    required this.height,
    required this.isDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _customDialog(context);
  }

  Widget _customDialogContents(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentTitle(title: 'Profile'),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: isDesktop ? 100 : 50,
                  backgroundColor: CustomColors.deepPurple,
                ),
                SizedBox(
                  height: isDesktop ? 50 : 25,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 5.0,
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Nick Name',
                        hintStyle: TextStyle(
                            color: CustomColors.deepPurple.withOpacity(0.5)),
                        label: null,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: _saveBtn(
                title: 'Save',
                color: CustomColors.whitePurple.withOpacity(0.8),
                onTap: () {}),
          ),
        ],
      ),
    );
  }

  Widget _saveBtn(
      {String title = '', Color? color, GestureTapCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 5.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(5.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CustomColors.white, fontSize: 15),
          ),
        ),
      ),
      color: color,
    );
  }

  Widget _customDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: width,
        height: height,
        child: _customDialogContents(context),
      ),
    );
  }
}
