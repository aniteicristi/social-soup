import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static MongoService get to => Get.find();
  static Db get db => Get.find<MongoService>()._db;

  late Db _db;

  Future init() async {
    final con = dotenv.get('MONGO_CONNECTION');
    this._db = await Db.create(con);
    await _db.open();
  }
}
