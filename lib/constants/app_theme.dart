/**
 * Creating custom color palettes is part of creating a custom app. The idea is to create
 * your class of custom colors, in this case `CompanyColors` and then create a `ThemeData`
 * object with those colors you just defined.
 *
 * Resource:
 * A good resource would be this website: http://mcg.mbitson.com/
 * You simply need to put in the colour you wish to use, and it will generate all shades
 * for you. Your primary colour will be the `500` value.
 *
 * Colour Creation:
 * In order to create the custom colours you need to create a `Map<int, Color>` object
 * which will have all the shade values. `const Color(0xFF...)` will be how you create
 * the colours. The six character hex code is what follows. If you wanted the colour
 * #114488 or #D39090 as primary colours in your theme, then you would have
 * `const Color(0x114488)` and `const Color(0xD39090)`, respectively.
 *
 * Usage:
 * In order to use this newly created theme or even the colours in it, you would just
 * `import` this file in your project, anywhere you needed it.
 * `import 'path/to/theme.dart';`
 */

import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
  fontFamily: 'ProductSans',
  brightness: Brightness.light,
  primarySwatch:
      MaterialColor(AppColors.primaryColor.value, AppColors.primarySwitch),
  primaryColor: AppColors.primaryColor,
  primaryColorBrightness: Brightness.light,
  accentColor: AppColors.primaryColor,
  accentColorBrightness: Brightness.light,
);

class AppColors {
  AppColors._(); // this basically makes it so you can instantiate this class

  static const Color primaryColor = Color(0xFF93c47d);

  static const Map<int, Color> primarySwitch = <int, Color>{
    50: Color(0xFFf2f8ef),
    100: Color(0xFFdfedd8),
    200: Color(0xFFc9e2be),
    300: Color(0xFFb3d6a4),
    400: Color(0xFFa3cd91),
    500: AppColors.primaryColor,
    600: Color(0xFF8bbe75),
    700: Color(0xFF80b66a),
    800: Color(0xFF76af60),
    900: Color(0xFF64a24d)
  };
}
