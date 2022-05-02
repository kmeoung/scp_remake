import 'package:flutter/material.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'dart:ui' as ui;

/// Project 기본 Title
class ContentTitle extends StatelessWidget {
  // Contents Title
  String title;
  VoidCallback? onTapMore;
  ContentTitle({
    Key? key,
    required this.title,
    this.onTapMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              // 그라데이션 필요할 시 추가
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: CustomColors.deepPurple,
              // foreground: Paint()
              //   ..shader = ui.Gradient.linear(
              //     const Offset(0, 20),
              //     const Offset(150, 20),
              //     <Color>[
              //       CustomColors.black.withOpacity(0.2),
              //       CustomColors.black,
              //     ],
              //   ),
            ),
            textAlign: TextAlign.left,
          ),
          Visibility(
            // 더보기 필요할 때에만 추가
            visible: onTapMore != null,
            child: IconButton(
              splashRadius: 20,
              iconSize: 40,
              onPressed: onTapMore,
              padding: EdgeInsets.zero,
              icon: const Icon(
                // 더보기 아이콘
                Icons.more_horiz,
                color: CustomColors.deepPurple,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      const Divider(
        // Title Divider
        color: CustomColors.yellow,
        thickness: 2,
        height: 5,
      ),
      // Divider(
      //   color: CustomColors.red,
      //   thickness: 2,
      // ),
      const SizedBox(
        height: 10,
      ),
    ]);
    ;
  }
}
