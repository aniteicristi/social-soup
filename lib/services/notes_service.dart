import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:social_soup/models/note.dart';
import 'package:social_soup/models/recipe.dart';
import 'package:social_soup/services/mongo_service.dart';
import 'package:social_soup/stores/auth_store.dart';

class NotesService {
  static NotesService get to => Get.find();

  Future<List<Rx<Note>>> getNotes(Rx<Recipe> recipe) async {
    final uid = AuthStore.to.currentUser.value!.id;

    final pipeline = AggregationPipelineBuilder()
        .addStage(Match(Expr(Eq(const Field('recipe'), recipe.value.id))))
        .addStage(_joinAuthor())
        .build();

    final result = await MongoService.db
        .collection('notes')
        .aggregateToStream(pipeline)
        .toList();

    return result.map((e) => Note.fromJson(e).obs).toList();
  }

  _joinAuthor() => Lookup(
        from: 'users',
        localField: 'user',
        foreignField: '_id',
        as: 'userObject',
      );
}
