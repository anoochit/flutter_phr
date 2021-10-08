import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData(context) {
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
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
    textTheme: GoogleFonts.robotoTextTheme(
      Theme.of(context).textTheme,
    ),
  );
}

final ThemeData darkTheme = ThemeData.dark();

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

const chipTextStyle = TextStyle(color: Colors.white);
