import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social_soup/global/app_colors.dart';
import 'package:social_soup/global/styles/heavy.dart';
import 'package:social_soup/global/styles/normal.dart';
import 'package:social_soup/models/recipe.dart';
import 'package:social_soup/services/reaction_service.dart';

class RecipeCard extends StatelessWidget {
  RecipeCard(this.recipe,
      {this.onUserPressed, this.onStarPressed, this.onPressed});

  Rx<Recipe> recipe;

  void Function()? onUserPressed;
  void Function()? onStarPressed;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ??
          () {
            Get.toNamed('/recipe', arguments: recipe);
          },
      child: Container(
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.value.title,
              style: HeavyStyle.big(),
            ),
            Divider(),
            Container(
              height: 150,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  recipe.value.image,
                  fit: BoxFit.fitWidth,
                  width: Get.width - 16,
                ),
              ),
            ).paddingOnly(bottom: 8),
            Text(
              recipe.value.caption,
              style: NormalStyle(),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          IconButton(
                            onPressed: onStarPressed ??
                                () async {
                                  if (recipe.value.starObject != null) {
                                    await ReactionService.to.unstar(recipe);
                                  } else {
                                    await ReactionService.to.star(recipe);
                                  }
                                },
                            icon: buildStar(),
                          ),
                          Text(
                            recipe.value.stars.toString(),
                            style: NormalStyle(),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notes_outlined,
                            color: AppColors.black,
                            size: 20,
                          ),
                        ),
                        Text(
                          recipe.value.notes.toString(),
                          style: NormalStyle(),
                        )
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: onUserPressed ??
                      () {
                        Get.toNamed('/profile', arguments: recipe.value.user);
                      },
                  child: Row(
                    children: [
                      SvgPicture.network(
                        recipe.value.userObject!.profilePicture,
                        width: Get.width * .1,
                      ),
                      Text(
                        '@${recipe.value.userObject?.handle}',
                        style: NormalStyle(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(color: AppColors.black),
          ],
        ),
      ),
    );
  }

  Widget buildStar() => recipe.value.starObject != null
      ? const Icon(Icons.star, color: AppColors.secondary)
      : const Icon(
          Icons.star_outline,
          color: AppColors.black,
        );
}
