import 'package:bson/src/classes/object_id.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:social_soup/models/recipe.dart';
import 'package:social_soup/models/user.dart';
import 'package:social_soup/services/mongo_service.dart';
import 'package:social_soup/stores/auth_store.dart';

class RecipeService {
  static RecipeService get to => Get.find();

  Future<List<Rx<Recipe>>> getUserRecipes(User user) async {
    final uid = AuthStore.to.currentUser.value!.id;

    final pipeline = AggregationPipelineBuilder()
        .addStage(Match(Expr(Eq(Field('user'), user.id))))
        .addStage(_joinStarred(uid))
        .build();

    final result = await MongoService.db
        .collection('recipes')
        .aggregateToStream(pipeline)
        .toList();

    return result.map((e) => Recipe.fromJson(e, obj: user).obs).toList();
  }

  Future<List<Rx<Recipe>>> getFeed() async {
    final uid = AuthStore.to.currentUser.value!.id;

    final pipeline = AggregationPipelineBuilder()
        .addStage(Match({
          'user': {
            r'$in': AuthStore.to.userFollowList,
          }
        }))
        .addStage(Sort({
          'createdAt': -1,
        }))
        .addStage(_joinAuthor())
        .addStage(_joinStarred(uid))
        .build();

    final result = await MongoService.db
        .collection('recipes')
        .aggregateToStream(pipeline)
        .toList();

    return result.map((e) => Recipe.fromJson(e).obs).toList();
  }

  Future<List<Rx<Recipe>>> getAllRecipes() async {
    final uid = AuthStore.to.currentUser.value!.id;

    final pipeline = AggregationPipelineBuilder()
        .addStage(_joinAuthor())
        .addStage(_joinStarred(uid))
        .build();

    final result = await MongoService.db
        .collection('recipes')
        .aggregateToStream(pipeline)
        .toList();

    return result.map((e) => Recipe.fromJson(e).obs).toList();
  }

  _joinAuthor() => Lookup(
        from: 'users',
        localField: 'user',
        foreignField: '_id',
        as: 'userObject',
      );

  _joinStarred(uid) => Lookup.withPipeline(
        from: 'stars',
        pipeline: [
          Match(Expr(And([
            Eq(Field('user'), Var('user')),
            Eq(Field('recipe'), Var('recipe')),
          ]))),
        ],
        let: {
          'user': uid,
          'recipe': Field('_id'),
        },
        as: 'starObject',
      );
}
