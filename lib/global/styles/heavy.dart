import 'package:flutter/cupertino.dart';
import 'package:social_soup/global/app_colors.dart';

class HeavyStyle extends TextStyle {
  HeavyStyle({Color? color})
      : super(
          fontSize: 16,
          color: color ?? AppColors.black,
          fontWeight: FontWeight.bold,
        );
  HeavyStyle.big({Color? color})
      : super(
          fontSize: 20,
          color: color ?? AppColors.black,
          fontWeight: FontWeight.bold,
        );
}
