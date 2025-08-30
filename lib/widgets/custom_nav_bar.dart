import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: GestureDetector(
        child: Row(
          children: [
            Icon(Icons.arrow_back_ios, color: Color(0xFF394675), size: 10),
            Text(
              'Back',
              style: TextStyle(
                height: 1.4,
                color: Color(0xFF394675),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
