import 'package:flutter/material.dart';
import 'package:submission8/widgets/custom_text.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.title, required this.subTitle});

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomBigText(text: title),
        SizedBox(height: 16),
        CustomSmallText(text: subTitle),
      ],
    );
  }
}
