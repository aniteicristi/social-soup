import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:social_soup/controllers/app_controller.dart';
import 'package:social_soup/global/app_colors.dart';
import 'package:social_soup/pages/explore_page.dart';
import 'package:social_soup/pages/home_page.dart';
import 'package:social_soup/pages/profile_page.dart';
import 'package:social_soup/widgets/app_bar.dart';

class AppPage extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final explore = ExplorePage();
    return Obx(() => Scaffold(
          body: Stack(
            children: [
              Offstage(
                offstage: controller.currentIndex.value != 0,
                child: ExplorePage(),
              ),
              Offstage(
                offstage: controller.currentIndex.value != 1,
                child: HomePage(),
              ),
              Offstage(
                offstage: controller.currentIndex.value != 2,
                child: ProfilePage(),
              ),
            ],
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.currentIndex.value = index,
            selectedItemColor: AppColors.primary,
            items: [
              SalomonBottomBarItem(
                  icon: const Icon(Icons.search), title: const Text('Explore')),
              SalomonBottomBarItem(
                  icon: const Icon(Icons.home_outlined),
                  title: const Text('Home')),
              SalomonBottomBarItem(
                  icon: const Icon(Icons.account_circle_outlined),
                  title: const Text('Account')),
            ],
          ),
        ));
  }
}
