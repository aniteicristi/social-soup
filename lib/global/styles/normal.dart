import 'package:flutter/cupertino.dart';
import 'package:social_soup/global/app_colors.dart';

class NormalStyle extends TextStyle {
  NormalStyle()
      : super(
          fontSize: 16,
          color: AppColors.grey,
        );

  NormalStyle.small()
      : super(
          fontSize: 12,
          color: AppColors.grey,
        );
}
