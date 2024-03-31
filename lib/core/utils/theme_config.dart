import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeColor {

  static Color grey = const Color(0xFF757575);
  static Color lightGrey = const Color(0xFF9E9E9E);
  static Color blueBgColor = const Color(0xFF2C5BDC);
  static Color textFieldBackgroundColor = const Color(0xFFFAFAFA);
  static Color greyDotColor = const Color(0xFFE0E0E0);
  static Color blueTextColor = const Color(0xFF2C5BDC);
  static Color borderColor = const Color(0xFFEEEEEE);
  static Color progressBackColor = const Color(0xFFD5FCDA);
  static Color badgeColor = const Color(0xFFFF7C70);
  static Color lightPrimary = const Color(0xff004B8D);
  static Color lightPrimary400 = const Color(0xff336FA4);
  static Color lightPrimary300 = const Color(0xff6693BB);
  static Color lightPrimary200 = const Color(0xff99B7D1);
  static Color lightPrimary100 = const Color(0xffCCDBE8);
  static Color lightPrimary50 = const Color(0xffF5F8FB);

  static Color colorTextBody = const Color(0xff334F76);
  static Color progressBarColor = const Color(0xffED1C24);
  static Color progressBarBackColor = const Color(0xffF8A4A7);

  static Color bodyText2 = const Color(0xff939598);
  static Color colorTextPrimary = const Color(0xff001C43);
  static Color colorTextSecondary = const Color(0xff27AE60);
  static Color colorTextThird = const Color(0xff667B98);
  static Color darkPrimary = const Color(0xff004B8D);
  static Color darkBlue = const Color(0xff002354);
  static Color lightBlue = const Color(0xff00AEEF);
  static Color lightAccent = const Color(0xff2ca8e2);
  static Color darkAccent = const Color(0xff2ca8e2);
  static Color lightBG = Colors.white;
  static Color darkBG = const Color(0xff121212);
  static Color lightTextColor = Colors.black;
  static Color darkTextColor = Colors.white;

  static Color border_bd_1 = const Color(0xffCCDBE8);


  static Color homeCardGrey = const Color(0xff7D7D7D);
  static Color bodyGrey = const Color(0xff585858);


  static const Color yellow_lite = Color(0xFFFECC00);
  static const Color yellow_dark = Color(0xFFFDB706);
  static const Color gray25 = Color(0xffA5A5A5);
  static const Color black = Color(0xFF000000);
  static const Color songColor = Color(0XFFF8FFD6);
  static const Color white = Color(0XFFFFFFFF);

  static Color color = Color(0XFFF8FFD6);

  static bool isClick = true;



  static MaterialColor orangeThemeColor = const MaterialColor(
    0xFFF57C51,
    <int, Color>{
      50: Color(0xFFF57C51),
      100: Color(0xFFF57C51),
      200: Color(0xFFF57C51),
      300: Color(0xFFF57C51),
      400: Color(0xFFF57C51),
      500: Color(0xFFF57C51),
      600: Color(0xFFF57C51),
      700: Color(0xFFF57C51),
      800: Color(0xFFF57C51),
      900: Color(0xFFF57C51),
    },
  );
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    backgroundColor: ThemeColor.lightBG,
    primaryColor: ThemeColor.lightPrimary,
    scaffoldBackgroundColor: ThemeColor.lightBG,
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme.light(
        primary: Colors.lightBlue,
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ThemeColor.lightAccent,
      brightness: Brightness.light,
    ),
    iconTheme: IconThemeData(color: ThemeColor.colorTextBody),
    textTheme: TextTheme(
      bodyText1: GoogleFonts.workSans(
        color: ThemeColor.lightTextColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        fontSize: 18,
        height: 0.28,
      ),
      bodyText2: GoogleFonts.workSans(
        color: ThemeColor.lightTextColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 0.24,
      ),
      button: GoogleFonts.workSans(
        color: ThemeColor.lightTextColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 0.22,
      ),
      caption: TextStyle(color: ThemeColor.lightTextColor),
      headline1: GoogleFonts.workSans(
        color: ThemeColor.lightTextColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        fontSize: 24,
        height: 0.36,
      ),
      headline2: GoogleFonts.workSans(
        color: ThemeColor.lightTextColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
      headline3: GoogleFonts.workSans(
        color: ThemeColor.lightTextColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 0.28,
      ),
      headline4: TextStyle(color: ThemeColor.lightTextColor),
      headline5: TextStyle(color: ThemeColor.lightTextColor),
      headline6: TextStyle(color: ThemeColor.lightTextColor),
      overline: TextStyle(color: ThemeColor.lightTextColor),
      subtitle1: GoogleFonts.workSans(
        color: ThemeColor.lightTextColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 0.22,
      ),
      subtitle2: GoogleFonts.workSans(
        color: ThemeColor.lightTextColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 0.18,
      ),
      bodySmall: GoogleFonts.workSans(
        color: ThemeColor.lightTextColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        fontSize: 10,
        height: 0.15,
      ),
    ),
    textSelectionTheme:
        TextSelectionThemeData(cursorColor: ThemeColor.lightAccent),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: ThemeColor.darkBG,
    primaryColor: ThemeColor.darkPrimary,
    scaffoldBackgroundColor: ThemeColor.darkBG,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme.light(
        primary: Colors.lightGreen,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ThemeColor.darkAccent,
      brightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(color: ThemeColor.colorTextBody),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: ThemeColor.darkTextColor),
      bodyText2: TextStyle(color: ThemeColor.darkTextColor),
      button: TextStyle(color: ThemeColor.darkTextColor),
      caption: TextStyle(color: ThemeColor.darkTextColor),
      headline1: TextStyle(color: ThemeColor.darkTextColor),
      headline2: TextStyle(color: ThemeColor.darkTextColor),
      headline3: TextStyle(color: ThemeColor.darkTextColor),
      headline4: TextStyle(color: ThemeColor.darkTextColor),
      headline5: TextStyle(color: ThemeColor.darkTextColor),
      headline6: TextStyle(color: ThemeColor.darkTextColor),
      overline: TextStyle(color: ThemeColor.darkTextColor),
      subtitle1: TextStyle(color: ThemeColor.darkTextColor),
      subtitle2: TextStyle(color: ThemeColor.darkTextColor),
    ),
    indicatorColor: ThemeColor.lightAccent,
    textSelectionTheme:
        TextSelectionThemeData(cursorColor: ThemeColor.darkAccent),
  );
}
