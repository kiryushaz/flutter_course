import 'package:flutter/material.dart';

import 'app_colors.dart';

sealed class ImageSources {
  static const locationIcon =
      Icon(Icons.location_on_outlined, color: CoffeeAppColors.primary);
  static const deleteIcon = Icon(Icons.delete);
  static const errorIcon = Icon(Icons.error);
  static const cartIcon = Icon(Icons.shopping_basket_outlined);
}
