import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:social_soup/global/app_colors.dart';
import 'package:social_soup/stores/auth_store.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    check();
  }

  Future check() async {
    await Future.delayed(1.seconds);
    await AuthStore.to.init();
    print('AAAAAAA');
    print(AuthStore.to.currentUser.value?.email);
    if (AuthStore.to.currentUser.value == null) {
      Get.offAllNamed('/login');
      return;
    }
    Get.offAllNamed('/app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: UnDraw(
          illustration: UnDrawIllustration.breakfast,
          color: AppColors.primary,
          width: Get.width * .3,
          height: Get.height * .2,
        ),
      ),
    );
  }
}
