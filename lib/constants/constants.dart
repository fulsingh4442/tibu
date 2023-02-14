import 'package:flutter/material.dart';

//const Color colorPrimary = Color(0xFF424242);
const Color colorPrimary = Color(0xFF25252d);
const Color colorPrimaryDark = Color(0xFF212121);
const Color colorAccent = Color(0xFFFFFFFF);
const Color cardBackgroundColor = Color(0xFF1e1f23);
const Color dividerColor = Colors.white;
const Color colorPrimaryText = Colors.white;
const Color colorSecondaryText = Colors.white54;
const Color textColorDarkPrimary = Colors.white;

const Color buttonTextColor = Colors.white;
const Color buttonBorderColor = Colors.white;
const Color buttonBackgroundColor = Colors.black;

//const Color textColorDarkPrimary = Colors.black87;
const Color textColorDarkSecondary = Colors.white70;
//const Color textColorDarkSecondary = Colors.black54;
const Color borderColor = Colors.white;
const Color backgroundColor = Color(0xFF616161);
//const Color appBackgroundColor = Color(0xFFECEFF1);
const Color appBackgroundColor = Colors.black87;
const Color transparentBlack = Color(0xA0000000);
const Color buttonBackground = Colors.red;
const Color bottomNavigationBackground = colorPrimary;
const Color navigationItemSelectedColor = textColorDarkPrimary;
const Color navigationItemUnSelectedColor = textColorDarkSecondary;
const Color detailsDividerColor = dividerColor;
const Color claimButtonColor = Color(0xFF18AF23);
const Color unClaimButtonColor = buttonBackground;
const Color drawerColor = Color(0xFF0C0F1C);

const MaterialColor primarySwatch = MaterialColor(
  _pSwatchPrimaryValue,
  <int, Color>{
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    350: Color(0xFFD6D6D6), // only for raised button while pressed in light theme
    400: Color(0xFFBDBDBD),
    500: Color(_pSwatchPrimaryValue),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    850: Color(0xFF303030), // only for background color in dark theme
    900: Color(0xFF212121),
  },
);
const int _pSwatchPrimaryValue = 0xFF424242;

const int eventListOffset = 10;
