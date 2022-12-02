import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:social_soup/controllers/home_controller.dart';
import 'package:social_soup/pages/profile.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot it'),
        leading: const Icon(
          Icons.account_circle_outlined,
        ),
      ),
      body: Center(
        child: Text('home'),
      ),
    );
  }
}
