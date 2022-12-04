import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:social_soup/global/app_colors.dart';
import 'package:social_soup/global/styles/normal.dart';
import 'package:social_soup/models/recipe.dart';
import 'package:social_soup/services/recipe_service.dart';
import 'package:social_soup/widgets/app_bar.dart';
import 'package:social_soup/widgets/loading_spinner.dart';
import 'package:social_soup/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RxBool loading = false.obs;

  List<Rx<Recipe>> recipes = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  createNew() {
    Get.toNamed('/recipe/create');
  }

  Future init() async {
    loading.value = true;
    try {
      recipes = await RecipeService.to.getFeed();
      loading.value = false;
    } catch (e) {
      Get.snackbar('Something went wrong', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: CustomAppBar('Feed'),
          body: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: loading.value
                ? LoadingSpinner()
                : RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.white,
                    onRefresh: init,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.primary),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.white)),
                                  onPressed: createNew,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(right: 16.0),
                                        child: Icon(Icons.note_add_outlined),
                                      ),
                                      Text(
                                        'Post your recipe!',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (loading.value)
                          LoadingSpinner()
                        else if (recipes.isEmpty)
                          buildEmpty()
                        else
                          ...recipes
                              .map((e) => RecipeCard(e).paddingOnly(bottom: 8)),
                      ],
                    )),
          )),
    );
  }

  Widget buildEmpty() => Column(
        children: [
          UnDraw(
              illustration: UnDrawIllustration.thoughts,
              color: AppColors.primary,
              width: Get.width * .3,
              height: Get.height * .2),
          Text(
            "It's lonely around here.\nFind new friends in the explore tab!",
            textAlign: TextAlign.center,
            style: NormalStyle(),
          ),
        ],
      ).paddingSymmetric(vertical: Get.height * .2);
}
