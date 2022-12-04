import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:social_soup/global/app_colors.dart';
import 'package:social_soup/global/styles/heavy.dart';
import 'package:social_soup/global/styles/normal.dart';
import 'package:social_soup/models/note.dart';
import 'package:social_soup/models/recipe.dart';
import 'package:social_soup/services/notes_service.dart';
import 'package:social_soup/services/reaction_service.dart';
import 'package:social_soup/services/recipe_service.dart';
import 'package:social_soup/stores/auth_store.dart';
import 'package:social_soup/widgets/app_bar.dart';
import 'package:social_soup/widgets/loading_spinner.dart';
import 'package:social_soup/widgets/note_card.dart';

class RecipePage extends StatefulWidget {
  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<Rx<Note>> notes = [];
  late Rx<Recipe> recipe;
  RxBool loading = true.obs;
  RxBool loadingNotes = true.obs;

  TextEditingController newNoteController = TextEditingController();
  FocusNode newNoteFocus = FocusNode();

  newNote() async {
    try {
      final note =
          await ReactionService.to.createNote(newNoteController.text, recipe);
      notes.add(note);
      newNoteController.clear();
      newNoteFocus.unfocus();
    } catch (e) {
      Get.snackbar('Something went wrong', '');
    }
  }

  @override
  void initState() {
    recipe = Get.arguments;
    init();
    super.initState();
  }

  Widget buildStar() => recipe.value.starObject != null
      ? const Icon(Icons.star, color: AppColors.secondary)
      : const Icon(
          Icons.star_outline,
          color: AppColors.black,
        );

  Future init() async {
    loading.value = true;
    loadingNotes.value = true;

    try {
      notes = await NotesService.to.getNotes(recipe);
      loadingNotes.value = false;
    } catch (e) {
      Get.snackbar('Something went wrong!', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          'Recipe',
          trailing: recipe.value.user == AuthStore.to.currentUser.value!.id
              ? TextButton(
                  onPressed: () async {
                    await RecipeService.to.delete(recipe);
                    Get.back();
                  },
                  child: Text(
                    'Delete',
                    style: HeavyStyle(color: AppColors.secondary),
                  ))
              : null,
        ),
        body: Obx(
          () => Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 30),
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.white,
                  onRefresh: init,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    children: [
                      Text(
                        recipe.value.title,
                        style: HeavyStyle.big(),
                      ),
                      Divider(),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          recipe.value.image,
                          fit: BoxFit.fitWidth,
                          width: Get.width - 16,
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
                                      onPressed: () async {
                                        if (recipe.value.starObject != null) {
                                          await ReactionService.to
                                              .unstar(recipe);
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
                            onPressed: () {
                              Get.toNamed('/profile',
                                  arguments: recipe.value.user);
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
                      Divider(),
                      Row(
                        children: [
                          Text(
                            'Tags',
                            style: HeavyStyle(),
                          )
                        ],
                      ),
                      Wrap(
                        children: [
                          ...recipe.value.tags.map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '#$e',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary),
                                ),
                              )),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Text(
                            'Instructions',
                            style: HeavyStyle(),
                          )
                        ],
                      ),
                      Wrap(
                        children: [
                          Text(
                            recipe.value.instructions,
                            style: NormalStyle(),
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Text(
                            'Ingredients',
                            style: HeavyStyle(),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ...recipe.value.ingredients.map((e) => Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    height: 10,
                                    width: 10,
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8),
                                  ),
                                  Text(
                                    e,
                                    style: NormalStyle(),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Text(
                            'Notes',
                            style: HeavyStyle(),
                          )
                        ],
                      ),
                      if (loadingNotes.value)
                        LoadingSpinner()
                      else
                        ...notes.map((e) => NoteCard(e)),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                  height: 50,
                  width: Get.width,
                  child: Card(
                    color: AppColors.accent,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: newNoteController,
                                focusNode: newNoteFocus,
                                cursorColor: AppColors.black,
                                decoration: const InputDecoration(
                                    hintText: 'Add a new note...',
                                    border: InputBorder.none),
                              ),
                            ),
                            IconButton(
                                onPressed: newNote,
                                icon: const Icon(
                                  Icons.send,
                                  color: AppColors.primary,
                                ))
                          ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
