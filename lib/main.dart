import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:social_soup/global/app_colors.dart';
import 'package:social_soup/pages/app_page.dart';
import 'package:social_soup/pages/explore_page.dart';
import 'package:social_soup/pages/login_page.dart';
import 'package:social_soup/pages/new_recipe_page.dart';
import 'package:social_soup/pages/profile_page.dart';
import 'package:social_soup/pages/recipe_page.dart';
import 'package:social_soup/pages/splash_page.dart';
import 'package:social_soup/services/mongo_service.dart';
import 'package:social_soup/services/notes_service.dart';
import 'package:social_soup/services/reaction_service.dart';
import 'package:social_soup/services/recipe_service.dart';
import 'package:social_soup/services/user_service.dart';
import 'package:social_soup/stores/auth_store.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dotenv.load(fileName: '.env');

  //Register services
  await Get.put(MongoService()).init();
  Get.put(UserService());
  Get.put(RecipeService());
  Get.put(ReactionService());
  Get.put(NotesService());

  //Register stores

  Get.put(AuthStore());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Social Soup',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white,
        primaryColor: AppColors.primary,
        secondaryHeaderColor: AppColors.secondary,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashPage()),
        GetPage(name: '/app', page: () => AppPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        // GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/recipe', page: () => RecipePage()),
        GetPage(name: '/recipe/create', page: () => NewRecipePage()),
        GetPage(name: '/explore', page: () => ExplorePage()),
      ],
    );
  }
}
