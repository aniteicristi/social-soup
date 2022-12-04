import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:social_soup/widgets/app_bar.dart';

class NewRecipePage extends StatefulWidget {
  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Write your recipe'),
      body: SafeArea(
        child: Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                children: [
                  Text('TODO'.obs.value),
                ],
              ),
            )),
      ),
    );
  }
}
