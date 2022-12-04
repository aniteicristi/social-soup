import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:social_soup/global/app_colors.dart';
import 'package:dartx/dartx.dart';
import 'package:social_soup/global/exceptions/not_found_exception.dart';
import 'package:social_soup/pages/app_page.dart';
import 'package:social_soup/stores/auth_store.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RxBool btnDisabled = false.obs;

  Future login() async {
    if (_formKey.currentState!.validate()) {
      btnDisabled.value = true;
      try {
        await AuthStore.to.login(email.text, pass.text);
        Get.offAll(() => AppPage());
      } catch (e) {
        Get.snackbar(
          '',
          e.toString(),
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.GROUNDED,
        );
      } finally {
        btnDisabled.value = false;
      }
    }
  }

  void register() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  UnDraw(
                    illustration: UnDrawIllustration.cooking,
                    color: AppColors.primary,
                    width: Get.width * .3,
                    height: Get.height * .2,
                  ),
                  const Text(
                    "Get your kitchen gloves on and hop in!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.primary, fontSize: 24),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    validator: (val) {
                      if (val?.isEmpty ?? true) return 'Must not be empty';
                      if (!val!.isEmail) return 'Must be valid email!';
                      return null;
                    },
                    controller: email,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2)),
                      prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    validator: (val) {
                      if (val?.isEmpty ?? true) return 'Must not be empty';
                      return null;
                    },
                    controller: pass,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2)),
                      prefixIcon: Icon(Icons.key, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Obx(
                        () => Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.primary),
                                foregroundColor:
                                    MaterialStateProperty.all(AppColors.white)),
                            onPressed: btnDisabled.value ? null : login,
                            child: Text(
                              btnDisabled.value ? 'Hold on...' : 'Login!',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            // TextButton(
            //   style: ButtonStyle(
            //       foregroundColor:
            //           MaterialStateProperty.all(AppColors.secondary)),
            //   onPressed: register,
            //   child: const Text(
            //     'Register',
            //     style: TextStyle(fontSize: 16),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
