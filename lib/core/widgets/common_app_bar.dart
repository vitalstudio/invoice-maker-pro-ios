import 'package:flutter/material.dart';
import '../../core/constants/color/color.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget{

  @override
  final Size preferredSize;
  final String? titleText;
  final IconData? iconRequire;
  final IconData? iconTick;
  final Function()? onPressed;
  final Function()? navigationPressed;

   const CommonAppBar({
    Key? key,
     this.titleText,
     this.iconRequire,
     this.onPressed,
     this.navigationPressed,
     this.iconTick,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: mainPurpleColor,
      leading: IconButton(
        onPressed: onPressed,
        icon: Icon(iconRequire,color: sWhite,),
      ),
      title: Text(titleText.toString(),style: const TextStyle(color: sWhite,fontWeight: FontWeight.bold,),),
      actions: [
        Row(
          children: [
            Container(),
            Container(),
            Container(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed:navigationPressed,
                icon: Icon(iconTick,color: sWhite,),
              ),
            ),
          ],
        )
      ],
    );
  }

}