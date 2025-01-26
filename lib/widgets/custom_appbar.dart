import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar({super.key, Color? textColor})
      : super(
          preferredSize: Size.fromHeight(50),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'pomodoro.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor ?? const Color.fromARGB(255, 179, 75, 240),
                  ),
                ),
              ],
            ),
          ),
        );
}
