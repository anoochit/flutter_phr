import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData(BuildContext context) {
  return ThemeData(
    primarySwatch: Colors.blue,
    canvasColor: Colors.grey.shade200,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 1.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
      ),
    ),
    cardTheme: const CardTheme(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
    textTheme: GoogleFonts.ubuntuTextTheme(
      Theme.of(context).textTheme,
    ),
  );
}

// FIXME : custome theme for dark mode
ThemeData themeDataDark(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;

  return ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      elevation: 1.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
      ),
    ),
    textTheme: GoogleFonts.ubuntuTextTheme(textTheme).copyWith(
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      headline6: TextStyle(
        color: Colors.white,
      ),
      button: TextStyle(
        color: Colors.white,
      ),
    ),
    cardTheme: const CardTheme(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
  );
}

const TextStyle textTitleStyle = TextStyle(
  fontWeight: FontWeight.w500,
);

const TextStyle textTitleStyleBig = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 24,
);

const TextStyle textSubTitleStyle = TextStyle(
  fontWeight: FontWeight.w400,
);

const TextStyle textHistroryButton = TextStyle(
  fontWeight: FontWeight.w500,
  color: Colors.red,
);

final buttonStyleRed = ButtonStyle(
  elevation: MaterialStateProperty.all(1),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: const BorderSide(color: Colors.red),
    ),
  ),
);

final buttonStyleGreen = ButtonStyle(
  elevation: MaterialStateProperty.all(1),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: const BorderSide(color: Colors.green),
    ),
  ),
);

final buttonStyleBlue = ButtonStyle(
  elevation: MaterialStateProperty.all(1),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: const BorderSide(color: Colors.blue),
    ),
  ),
);

final buttonStyleAmber = ButtonStyle(
  elevation: MaterialStateProperty.all(1),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: const BorderSide(color: Colors.amber),
    ),
  ),
);
