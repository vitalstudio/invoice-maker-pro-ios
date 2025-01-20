import 'package:flutter/material.dart';
import '../../core/constants/color/color.dart';

class CustomSettingContainer extends StatelessWidget {
  const CustomSettingContainer({Key? key, this.onTap,this.title,this.subTitle, this.iconData}) : super(key: key);

  final Function()? onTap;
  final String? title;
  final String? subTitle;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: sWhite,
        borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: shadowColor,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(2, 2)),
          ],
      ),

      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        leading: Icon(
          iconData,
          size: 20,
          color: mainPurpleColor,
        ),
        title: Text(title.toString(),
        style: const TextStyle(
            fontFamily: 'Montserrat',
          color: mainPurpleColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
       ),
       subtitle: Visibility(
         visible: subTitle != '',
         child: Text(subTitle.toString(),
           style: const TextStyle(
            fontFamily: 'Montserrat',
             color: grey_1,
             fontWeight: FontWeight.w400,
             fontSize: 12,
           ),
         ),
       ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,color: mainPurpleColor,size: 15,),
     ),
    );
  }
}
