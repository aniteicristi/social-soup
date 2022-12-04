import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:social_soup/services/user_service.dart';
import 'package:social_soup/models/user.dart' as model;

class AuthStore {
  static AuthStore get to => Get.find();

  Rx<model.User?> currentUser = (null as model.User?).obs;

  List<ObjectId> get userFollowList {
    return AuthStore.to.currentUser.value?.followList
            ?.map((e) => e.followed)
            .toList() ??
        [];
  }

  Future login(String email, String password) async {
    print('doing');
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    await init();

    return currentUser;
  }

  Future init() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    var authId = FirebaseAuth.instance.currentUser!.uid;

    currentUser.value = await UserService.to.getByAuth(authId);
  }
}
