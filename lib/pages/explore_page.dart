import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:social_soup/global/app_colors.dart';
import 'package:social_soup/global/styles/heavy.dart';
import 'package:social_soup/global/styles/normal.dart';
import 'package:social_soup/models/recipe.dart';
import 'package:social_soup/services/recipe_service.dart';
import 'package:social_soup/widgets/app_bar.dart';
import 'package:social_soup/widgets/loading_spinner.dart';
import 'package:social_soup/widgets/recipe_card.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  RxList<Rx<Recipe>> recipes = <Rx<Recipe>>[].obs;
  RxBool searched = false.obs;
  RxBool loading = false.obs;
  TextEditingController tagController = TextEditingController();
  Future search() async {
    try {
      searched.value = true;
      loading.value = true;

      recipes.value = await RecipeService.to.searchByTag(tagController.text);
      loading.value = false;
    } catch (e) {
      Get.snackbar('Something went wrong!', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar('Explore'),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.white,
              onRefresh: search,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                children: [
                  buildSearch(),
                  if (loading.value)
                    LoadingSpinner().paddingSymmetric(vertical: Get.height * .2)
                  else if (searched.value)
                    if (recipes.isEmpty)
                      buildEmpty()
                    else
                      ...recipes.map((e) => RecipeCard(e))
                  else
                    buildStart(),
                ],
              ),
            )),
      ),
    );
  }

  Widget buildSearch() => TextField(
        controller: tagController,
        cursorColor: AppColors.black,
        decoration: InputDecoration(
            hintText: 'Tag search',
            prefixText: '#',
            prefixStyle: const TextStyle(color: AppColors.primary),
            suffixIcon: IconButton(
                onPressed: search,
                icon: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                )),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            )),
      );

  Widget buildStart() => Column(
        children: [
          UnDraw(
            illustration: UnDrawIllustration.trends,
            color: AppColors.primary,
            width: Get.width * .2,
            height: Get.height * .15,
          ),
          Text(
            'Search for any tag that comes to mind!',
            style: NormalStyle(),
          ),
        ],
      ).paddingSymmetric(vertical: Get.height * .2);

  Widget buildEmpty() => Column(
        children: [
          UnDraw(
              illustration: UnDrawIllustration.empty,
              color: AppColors.primary,
              width: Get.width * .3,
              height: Get.height * .2),
          Text(
            'No ${tagController.text} recipes found',
            style: NormalStyle(),
          ),
        ],
      ).paddingSymmetric(vertical: Get.height * .2);
}
