import 'package:flutter/material.dart';

ThemeData themeData(BuildContext context, ColorScheme? lightDynamic) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: lightDynamic,
  );
}

ThemeData themeDataDark(BuildContext context, ColorScheme? darkDynamic) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: darkDynamic,
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
