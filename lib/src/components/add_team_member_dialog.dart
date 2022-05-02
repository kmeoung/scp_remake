import 'package:flutter/material.dart';
import 'package:refactory_scp/src/common/colors.dart';

import 'content_title.dart';

/// 팀원 추가 Dialog
class AddTeamMemberDialog extends StatelessWidget {
  // 가로 사이즈
  double width;
  // 세로 사이즈
  double height;
  AddTeamMemberDialog({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _customDialog(context);
  }

  // Dialog Contents
  Widget _customDialogContents(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentTitle(title: 'Team Member Select'),
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
                  hintText: 'Search Team Member',
                  hintStyle: TextStyle(
                      color: CustomColors.deepPurple.withOpacity(0.5)),
                  label: null,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              children: List.generate(
                20,
                (index) => ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  leading: const CircleAvatar(
                    backgroundColor: CustomColors.deepPurple,
                    foregroundColor: Colors.transparent,
                  ),
                  title: Text(
                    'Name $index',
                    style: TextStyle(color: CustomColors.deepPurple),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Dialog 전체
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
