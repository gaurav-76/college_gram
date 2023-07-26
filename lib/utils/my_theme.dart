import 'package:flutter/material.dart';

import 'colors.dart';

class ThemeProvider extends ChangeNotifier {
 
}

class MyTheme {
  static ThemeData lightTheme() => ThemeData(
        scaffoldBackgroundColor: lightMobileBackgroundColor,
        primarySwatch: Colors.grey,
        primaryColor: const Color.fromARGB(255, 37, 36, 36),
        brightness: Brightness.light,
        backgroundColor: Color(0xFFd9d9d9),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.grey,
          selectionHandleColor: Colors.black,
        ),
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.light)
            .copyWith(secondary: Colors.grey),
      );
}
