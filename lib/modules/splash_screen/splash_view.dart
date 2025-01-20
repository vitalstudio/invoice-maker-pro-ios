import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.startTimerForSplash();

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout(context)
        : mainDesktopLayout(context);
  }

  Widget mainMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPurpleColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
              color: splashTopBarColor
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: Transform.scale(
              scale: 1.4,
              child: Image.asset(
                'assets/icons/top.png',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            alignment: Alignment.center,
            child: Image.asset('assets/icons/icon_bill.png'),
          ),
          const SizedBox(
            width: double.infinity,
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 70),
            alignment: Alignment.center,
            child: Image.asset('assets/icons/name.png'),
          ),
          const SizedBox(
            width: double.infinity,
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget mainDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPurpleColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: Transform.scale(
                scale: 1.2,
                child: Image.asset(
                  'assets/icons/top.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 15,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              margin: const EdgeInsets.symmetric(horizontal: 70),
              alignment: Alignment.center,
              child: Image.asset('assets/icons/icon_bill.png'),
            ),
            const SizedBox(
              width: double.infinity,
              height: 15,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              margin: const EdgeInsets.symmetric(horizontal: 60),
              alignment: Alignment.center,
              child: Image.asset('assets/icons/name.png'),
            ),
            const SizedBox(
              width: double.infinity,
              height: 10,
            ),
        
          ],
        ),
      ),
    );
  }
}
