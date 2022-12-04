import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:social_soup/global/exceptions/generic_exception.dart';
import 'package:social_soup/global/exceptions/not_found_exception.dart';
import 'package:social_soup/models/user.dart';
import 'package:social_soup/services/mongo_service.dart';

class UserService {
  static UserService get to => Get.find();

  Future<User> getByAuth(String authId) async {
    final pipeline = AggregationPipelineBuilder()
        .addStage(Match(Expr(Eq(Field('auth_id'), authId))))
        .addStage(_joinFollowed())
        .build();

    final result = await MongoService.db
        .collection('users')
        .aggregateToStream(pipeline)
        .toList();

    if (result.isEmpty) throw NotFoundException('User does not exist!');
    return User.fromJson(result.first);
  }

  Future<User> get(ObjectId id) async {
    final result = await MongoService.db.collection('users').findOne({
      '_id': id,
    });
    if (result == null) throw NotFoundException('User does not exist!');
    return User.fromJson(result);
  }

  _joinFollowed() => Lookup.withPipeline(
        from: 'follow',
        pipeline: [
          Match(Expr(
            Eq(Field('follower'), Var('user')),
          )),
        ],
        let: {
          'user': Field('_id'),
        },
        as: 'followList',
      );
}
