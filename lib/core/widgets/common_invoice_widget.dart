import 'package:flutter/material.dart';
import '../../core/constants/color/color.dart';

class CommonInvoiceContainer extends StatelessWidget{
  final String? leadingText;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final String? trailingText;
  // final Function()? onPressed;

  const CommonInvoiceContainer({super.key,
    this.leadingText,
    this.leadingIcon,
    this.trailingIcon,
    this.trailingText = ''});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              child:  Row(
                children: [
                  Icon(leadingIcon,color: grey_1,),
                  const SizedBox(width: 15,),
                  Text(leadingText.toString(),style: const TextStyle(color: grey_1,fontWeight: FontWeight.w600,fontSize: 15),)
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  Text(trailingText.toString(),style: const TextStyle(color: grey_1),),
                  const SizedBox(width: 10,),
                  Icon(trailingIcon,color: grey_1,size: 15,)
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

}