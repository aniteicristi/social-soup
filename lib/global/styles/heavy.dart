import 'package:flutter/cupertino.dart';
import 'package:social_soup/global/app_colors.dart';

class HeavyStyle extends TextStyle {
  HeavyStyle()
      : super(
          fontSize: 16,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        );
  HeavyStyle.big()
      : super(
          fontSize: 20,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        );
}
