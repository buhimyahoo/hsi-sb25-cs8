import 'package:flutter/material.dart';

class CustomRegularText extends StatelessWidget {
  const CustomRegularText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        height: 1.4,
        color: Color(0xFF180E25),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      ),
    );
  }
}

class CustomBigText extends StatelessWidget {
  const CustomBigText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        height: 1.2,
        color: Color(0xFF180E25),
        fontSize: 24,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
      ),
      maxLines: 2,
    );
  }
}

class CustomSmallText extends StatelessWidget {
  const CustomSmallText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        height: 1.4,
        color: Color(0xFF827D89),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
      ),
      maxLines: 5,
    );
  }
}
