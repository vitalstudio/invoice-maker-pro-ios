import 'package:flutter/material.dart';

import '../constants/color/color.dart';

class CustomContainerDecoration {
  static BoxDecoration myCustomDecoration() {
    return BoxDecoration(
        color: sWhite,
        borderRadius: BorderRadius.circular(10),
      boxShadow:  const [
        BoxShadow(
            color: shadowColor,
            spreadRadius: 0.5,
            offset: Offset(1.5, 1.5)
        ),
        BoxShadow(
            color: shadowColor,
            spreadRadius: 0.3,
            offset: Offset(-0.25, -0.25)
        ),
      ]
    );
  }
}
