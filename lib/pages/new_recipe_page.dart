import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_soup/global/app_colors.dart';
import 'package:social_soup/global/styles/normal.dart';
import 'package:social_soup/services/cloud_storage_service.dart';
import 'package:social_soup/services/recipe_service.dart';
import 'package:social_soup/widgets/app_bar.dart';

class NewRecipePage extends StatefulWidget {
  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {
  final GlobalKey _formKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  RxList<String> ingredients = <String>[].obs;
  RxList<String> tags = <String>[].obs;

  Rx<String?> photoPath = Rx<String?>(null);

  RxBool posting = false.obs;

  Future post() async {
    try {
      posting.value = true;
      final recipe = await RecipeService.to.create({
        "title": titleController.text,
        "caption": captionController.text,
        "instructions": instructionsController.text,
        if (photoPath.value != null)
          "image":
              await CloudStorageService.to.uploadPhoto(File(photoPath.value!)),
        "tags": tags.value,
        "ingredients": ingredients.value,
      });
      posting.value = false;
      Get.back();
    } catch (e) {
      Get.snackbar("Something went wrong!", '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Write your recipe'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: [
                TextFormField(
                  validator: (val) {
                    if (val?.isEmpty ?? true) return 'Must not be empty';
                    if (val!.length > 200) return 'Length must be under 200';
                    return null;
                  },
                  controller: titleController,
                  cursorColor: AppColors.black,
                  decoration: buildInputDecoration('Title'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (val) {
                    if (val?.isEmpty ?? true) return 'Must not be empty';
                    if (val!.length > 500) return 'Length must be under 500';
                    return null;
                  },
                  controller: captionController,
                  cursorColor: AppColors.black,
                  decoration: buildInputDecoration('Caption'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => photoPath.value == null
                      ? buildPlaceholderPhoto()
                      : buildPhoto(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (val) {
                    if (val?.isEmpty ?? true) return 'Must not be empty';
                    if (val!.length > 500) return 'Length must be under 1000';
                    return null;
                  },
                  controller: instructionsController,
                  cursorColor: AppColors.black,
                  decoration: buildInputDecoration('Instructions'),
                  maxLines: 6,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: ingredientsController,
                  cursorColor: AppColors.black,
                  decoration: InputDecoration(
                    hintText: 'Ingredients',
                    suffixIconColor: AppColors.primary,
                    suffixIcon: IconButton(
                        onPressed: () {
                          ingredients.add(ingredientsController.text);
                          ingredientsController.clear();
                        },
                        icon: const Icon(
                          Icons.add_outlined,
                          color: AppColors.primary,
                        )),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                Obx(() => Column(
                      children: [...ingredients.map(buildIngredient)],
                    )),
                const SizedBox(height: 20),
                TextFormField(
                  controller: tagsController,
                  cursorColor: AppColors.black,
                  decoration: InputDecoration(
                      hintText: 'Tags',
                      prefixText: '#',
                      prefixStyle: const TextStyle(color: AppColors.primary),
                      suffixIcon: IconButton(
                          onPressed: () {
                            tags.add(tagsController.text);
                            tagsController.clear();
                          },
                          icon: const Icon(
                            Icons.add_outlined,
                            color: AppColors.primary,
                          )),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      )),
                ),
                Obx(() => Wrap(
                      children: [...tags.map(buildTag)],
                    )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Obx(
                      () => Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(AppColors.primary),
                              foregroundColor:
                                  MaterialStateProperty.all(AppColors.white)),
                          onPressed: posting.value ? null : post,
                          child: Text(
                            posting.value ? 'Hold on...' : 'Post!',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPhoto() => Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.file(
              File(photoPath.value!),
              fit: BoxFit.fitWidth,
              width: Get.width - 16,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  photoPath.value = null;
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.white,
                )),
          )
        ],
      );

  Widget buildPlaceholderPhoto() => Container(
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(
              BorderSide(width: 1, color: Color.fromARGB(255, 179, 179, 179))),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        width: Get.width - 32,
        height: 150,
        child: Center(
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.primary),
                  foregroundColor: MaterialStateProperty.all(AppColors.white)),
              onPressed: () async {
                final file =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                photoPath.value = file?.path;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.camera_alt_outlined),
                  ),
                  Text(
                    'Add a photo!',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
        ),
      );

  Widget buildTag(String tag) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '#$tag',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
            IconButton(
                constraints: BoxConstraints.tight(Size(24, 24)),
                padding: EdgeInsets.zero,
                onPressed: () => tags.remove(tag),
                icon: const Icon(
                  Icons.close,
                  size: 12,
                  color: AppColors.grey,
                ))
          ],
        ),
      );

  Widget buildIngredient(String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.grey,
              shape: BoxShape.circle,
            ),
            height: 10,
            width: 10,
            margin: const EdgeInsets.only(left: 8, right: 8),
          ),
          Text(
            text,
            style: NormalStyle(),
          ),
          Spacer(),
          IconButton(
              onPressed: () => ingredients.remove(text),
              icon: const Icon(
                Icons.close,
                size: 12,
                color: AppColors.grey,
              ))
        ],
      );

  buildInputDecoration(String hint) => InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2)),
      );
}
