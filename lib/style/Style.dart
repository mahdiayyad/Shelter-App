import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

//*************************************************************************************/
//**************************************STYLE******************************************/
//*************************************************************************************/

/// This is main style for all the app
class Style {
  /// The primary color
  static const Color primary = Colors.white;

  /// The secondary color
  static const Color secondary = Color(0xffFA6650);
  static const appbarColor = Color(0xffE8E8E8);
  static const Color lightGrey = Color(0xffDCDCDE);
  static const Color error = Color(0xffE0797A);
  static const Color primaryVariant = Color(0xffB3ACB4);
  static const Color secondaryVariant = Color(0xffFFE3DA);
  static const Color surface = Colors.white;
  static const Color background = Colors.white;

/*************************************************************************************/

  /// The app color scheme
  static ColorScheme colorScheme = ColorScheme(
    primary: secondary,
    primaryVariant: primaryVariant,
    secondary: secondary,
    secondaryVariant: secondaryVariant,
    surface: surface,
    background: background,
    error: error,
    onPrimary: primary,
    onSecondary: secondary,
    onSurface: surface,
    onBackground: background,
    onError: error,
    brightness: Brightness.light,
  );

  /// The app en font
  static late TextTheme rudaTextTheme;

  /// The app en font
  static late TextTheme almaraiTextTheme;

  /// this function is  used to get the text theme at [context]
  static TextTheme getFont(BuildContext context) {
    return context.locale.languageCode == 'en'
        ? Style.rudaTextTheme
        : Style.almaraiTextTheme.copyWith();
  }

  /// The main theme of the app
  static late ThemeData mainTheme;

  static void _setTextTheme(BuildContext context) {
    rudaTextTheme = GoogleFonts.rudaTextTheme(
      Theme.of(context).textTheme.apply(displayColor: Colors.black),
    );
    almaraiTextTheme = GoogleFonts.almaraiTextTheme(
      Theme.of(context).textTheme.apply(
            displayColor: Colors.black,
          ),
    );
  }

  static ThemeData appTheme(
    BuildContext context,
  ) {
    _setTextTheme(context);
    final appBarTheme = AppBarTheme(
        elevation: 0.0,
        centerTitle: false,
        actionsIconTheme: const IconThemeData(),
        titleTextStyle: rudaTextTheme.headline6!.copyWith(),
        color: Colors.transparent,
        iconTheme: const IconThemeData());
    return mainTheme = ThemeData(
        appBarTheme: appBarTheme,
        brightness: Brightness.light,
        colorScheme: colorScheme,

        // primaryColor: primaryColor,
        // accentColor: accentColor,
        textTheme: getFont(context),
        backgroundColor: background,
        scaffoldBackgroundColor: background);
  }

/*************************************************************************************/

  /// The rounded shape for cards and containers
  static RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
  );

  /// The rounded border for the textfields
  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Style.lightGrey,
      ));

  /// The rounded shape for cards and containers with the secondary color
  static OutlineInputBorder inAppOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Style.secondary,
      ));

  /// The rounded border for the textfields at [context]
  static InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
        border: outlineInputBorder,
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        errorBorder: outlineInputBorder.copyWith(
            borderSide: BorderSide(color: Style.colorScheme.error)),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        disabledBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder);
  }

  /// The rounded border for the textfields with the secondary color at [context]
  static InputDecoration inAppInputDecoration(BuildContext context) {
    return InputDecoration(
        hintStyle: getFont(context).subtitle1?.copyWith(color: secondary),
        border: inAppOutlineInputBorder,
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        errorBorder: inAppOutlineInputBorder.copyWith(
            borderSide: BorderSide(color: Style.colorScheme.error)),
        enabledBorder: inAppOutlineInputBorder,
        focusedBorder: inAppOutlineInputBorder,
        disabledBorder: inAppOutlineInputBorder,
        focusedErrorBorder: inAppOutlineInputBorder);
  }
}
