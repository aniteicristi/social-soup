import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:social_soup/global/app_colors.dart';
import 'package:social_soup/global/styles/heavy.dart';
import 'package:social_soup/global/styles/normal.dart';
import 'package:social_soup/models/recipe.dart';
import 'package:social_soup/models/user.dart';
import 'package:social_soup/services/reaction_service.dart';
import 'package:social_soup/services/recipe_service.dart';
import 'package:social_soup/services/user_service.dart';
import 'package:social_soup/stores/auth_store.dart';
import 'package:social_soup/widgets/app_bar.dart';
import 'package:social_soup/widgets/loading_spinner.dart';
import 'package:social_soup/widgets/recipe_card.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Rx<User> user;

  Rx<bool> loading = false.obs;
  Rx<bool> recipesLoading = false.obs;
  List<Rx<Recipe>> recipes = [];
  mongo.ObjectId? id;

  @override
  void initState() {
    super.initState();
    id = Get.arguments;
    init();
  }

  Future unfollow() async {
    try {
      await ReactionService.to.unfollow(user);
    } catch (e) {
      Get.snackbar('Something went wrong', '');
    }
  }

  Future follow() async {
    try {
      await ReactionService.to.follow(user);
    } catch (e) {
      Get.snackbar('Something went wrong', '');
    }
  }

  Future init() async {
    try {
      loading.value = true;
      recipesLoading.value = true;

      if (id == null) {
        user = AuthStore.to.currentUser.value!.obs;
      } else {
        user = (await UserService.to.get(id!)).obs;
      }
      loading.value = false;

      recipes = await RecipeService.to.getUserRecipes(user.value);
      recipesLoading.value = false;
    } catch (e) {
      Get.snackbar('Something went wrong', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Profile',
        trailing: id == null
            ? TextButton(
                onPressed: () async {
                  await AuthStore.to.logout();
                  Get.offAllNamed('/login');
                },
                child: Text(
                  'Logout',
                  style: HeavyStyle(color: AppColors.secondary),
                ))
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Obx(
          () => loading.value
              ? LoadingSpinner()
              : RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.white,
                  onRefresh: init,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.network(
                            user.value.profilePicture,
                            width: Get.width * .3,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.value.email, style: HeavyStyle()),
                              Text('@${user.value.handle}',
                                  style: NormalStyle()),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.grey,
                            size: 14,
                          ).paddingOnly(right: 8),
                          Text(
                            'Member since ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(user.value.joinedAt)}',
                            style: NormalStyle.small(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      if (id != null)
                        Row(
                          children: [
                            Expanded(
                              child: AuthStore.to.currentUser.value!.followList!
                                      .any((element) =>
                                          element.followed == user.value.id)
                                  ? OutlinedButton(
                                      onPressed: unfollow,
                                      child: Text('Unfollow',
                                          style: NormalStyle()))
                                  : ElevatedButton(
                                      onPressed: follow,
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppColors.primary),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  AppColors.white)),
                                      child:
                                          Text('Follow', style: NormalStyle())),
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Icon(
                                Icons.restaurant,
                                color: AppColors.primary,
                              ),
                              Text(
                                '${user.value.recipes} recipes',
                                style: NormalStyle.small(),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.signal_cellular_alt,
                                color: AppColors.primary,
                              ),
                              Text(
                                '${user.value.followers} followers',
                                style: NormalStyle.small(),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.connect_without_contact_outlined,
                                color: AppColors.primary,
                              ),
                              Text(
                                '${user.value.followes} followed',
                                style: NormalStyle.small(),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Recipes',
                            style: HeavyStyle(),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      if (recipesLoading.value)
                        LoadingSpinner()
                      else
                        ...recipes.map((r) => RecipeCard(r)),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
