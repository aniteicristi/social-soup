import 'package:flutter/material.dart';
import 'package:social_soup/global/app_colors.dart';

class CustomAppBar extends AppBar {
  CustomAppBar(String title, {Widget? trailing})
      : super(
            title: Text(
              title,
              style: TextStyle(color: AppColors.primary),
            ),
            foregroundColor: AppColors.black,
            backgroundColor: AppColors.white,
            elevation: 1,
            actions: [
              if (trailing != null) trailing,
            ]);
}
