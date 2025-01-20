import 'package:flutter/material.dart';
import '../constants/color/color.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({Key? key, this.childContainer,
    this.horizontalPadding, this.verticalPadding}) : super(key: key);

  final Widget? childContainer;
  final double? horizontalPadding;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 00 ,vertical: verticalPadding ?? 00),
      decoration: BoxDecoration(
        color: offWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: shadowColor,
              blurRadius: 5,
              offset: Offset(3, 3)
          ),
        ],
      ),
      child: childContainer,
    );
  }
}
