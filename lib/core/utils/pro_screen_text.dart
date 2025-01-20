import 'package:flutter/material.dart';

import '../constants/color/color.dart';

class ProScreenTextRow extends StatelessWidget {
  const ProScreenTextRow({super.key, required this.iconData, required this.text});

  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData,
          color: mainPurpleColor,
          size: 20,
        ),
         const SizedBox(width: 5,),
         Expanded(
           child: Text(
            text,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                color: blackColor,
                fontWeight: FontWeight.w700,
                fontSize: 14),
                   ),
         ),
      ],
    );
  }
}
