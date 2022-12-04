import 'package:dartx/dartx.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:social_soup/models/follow.dart';
import 'package:social_soup/models/note.dart';
import 'package:social_soup/models/recipe.dart';
import 'package:social_soup/models/star.dart';
import 'package:social_soup/models/user.dart';
import 'package:social_soup/services/mongo_service.dart';
import 'package:social_soup/stores/auth_store.dart';

class ReactionService {
  static ReactionService get to => Get.find();

  Future<Rx<Note>> createNote(String noteStr, Rx<Recipe> recipe) async {
    final result = await MongoService.db.collection('notes').insertOne({
      '_id': ObjectId(),
      'note': noteStr,
      'recipe': recipe.value.id,
      'user': AuthStore.to.currentUser.value!.id,
    });
    final note = Note.fromJson(result.document!);

    final res2 = await MongoService.db.collection('recipes').updateOne(
          where.eq('_id', recipe.value.id),
          modify.inc('notes', 1),
        );
    recipe.update((val) {
      val!.notes++;
    });

    note.userObject = AuthStore.to.currentUser.value!;
    return note.obs;
  }

  Future star(Rx<Recipe> recipe) async {
    final self = AuthStore.to.currentUser;

    if (recipe.value.starObject != null) return;

    final result = await MongoService.db.collection('stars').insertOne({
      '_id': ObjectId(),
      'user': self.value!.id,
      'recipe': recipe.value.id,
    });

    final star = Star.fromJson(result.document!);

    final res2 = await MongoService.db.collection('recipes').updateOne(
          where.eq('_id', recipe.value.id),
          modify.inc('stars', 1),
        );

    recipe.update((val) {
      val!.starObject = star;
      val.stars++;
    });
  }

  Future unstar(Rx<Recipe> recipe) async {
    if (recipe.value.starObject == null) return;

    final result = await MongoService.db.collection('stars').deleteOne({
      '_id': recipe.value.starObject!.id,
    });
    final res2 = await MongoService.db.collection('recipes').updateOne(
          where.eq('_id', recipe.value.id),
          modify.inc('stars', -1),
        );

    recipe.update((val) {
      val!.starObject = null;
      val.stars--;
    });
  }

  Future follow(Rx<User> user) async {
    final self = AuthStore.to.currentUser;
    if (self.value!.followList!
        .any((element) => element.followed == user.value.id)) {
      return;
    }

    final result = await MongoService.db.collection('follow').insertOne({
      '_id': ObjectId(),
      'follower': self.value!.id,
      'followed': user.value.id,
    });

    final follow = Follow.fromJson((result.document!));

    final res2 = await MongoService.db.collection('users').updateOne(
          where.eq('_id', self.value!.id),
          modify.inc('followes', 1),
        );

    self.update((val) {
      val!.followList!.add(follow);
      val.followes++;
    });

    final res3 = await MongoService.db.collection('users').updateOne(
          where.eq('_id', user.value.id),
          modify.inc('followers', 1),
        );

    user.update((val) {
      val!.followers++;
    });
  }

  Future unfollow(Rx<User> user) async {
    final self = AuthStore.to.currentUser;
    final follow = self.value!.followList!
        .where((element) => element.followed == user.value.id)
        .firstOrNull;
    if (follow == null) {
      return;
    }

    await MongoService.db.collection('follow').deleteOne({
      '_id': follow.id,
    });

    final res2 = await MongoService.db.collection('users').updateOne(
          where.eq('_id', self.value!.id),
          modify.inc('followes', -1),
        );

    self.update((val) {
      val!.followList!.remove(follow);
      val.followes--;
    });

    final res3 = await MongoService.db.collection('users').updateOne(
          where.eq('_id', user.value.id),
          modify.inc('followers', -1),
        );
    user.update((val) {
      val!.followers--;
    });
  }
}
