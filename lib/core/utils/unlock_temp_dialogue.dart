// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../constants/color/color.dart';
// import '../routes/routes.dart';
//
// class UnlockData{
//   static Future showUnlockTempDialogue({Function()? onWatchAdPressed}) async{
//     return Get.dialog(AlertDialog(
//       title: Container(
//         alignment: Alignment.center,
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(7),
//           color: mainPurpleColor,
//         ),
//         child: const Text('Template Locked',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               color: sWhite,
//               fontSize: 16,
//               fontFamily: 'Montserrat'
//           ),
//         ),
//       ),
//
//       content: const Text('Unlock template by subscription OR by watching Ads',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             color: blackColor,
//             fontSize: 16,
//             fontFamily: 'Montserrat'
//         ),
//       ),
//       actionsAlignment: MainAxisAlignment.center,
//       actions: [
//         TextButton(
//           onPressed: (){
//             Get.toNamed(Routes.proScreenView);
//           },
//           style: TextButton.styleFrom(
//             backgroundColor: greenColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(7)
//             )
//           ),
//           child: const Text('Buy Subscription',
//             style: TextStyle(
//                 color: sWhite,
//                 fontFamily: 'Montserrat'
//             ),
//           ),),
//         TextButton(
//           onPressed: onWatchAdPressed,
//           style: TextButton.styleFrom(
//               backgroundColor: redTemplate,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(7)
//               )
//           ),
//           child: const Text('Watch Ads',
//             style: TextStyle(
//                 color: sWhite,
//                 fontFamily: 'Montserrat'
//             ),
//           ),),
//       ],
//     ));
//   }
// }