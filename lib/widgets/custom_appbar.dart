import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar({super.key})
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
                    color: const Color.fromARGB(255, 179, 75, 240),
                  ),
                ),
              ],
            ),
          ),
        );
}
