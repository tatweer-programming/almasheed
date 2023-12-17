import 'package:flutter/material.dart';

import 'color_manager.dart';

ThemeData getAppTheme() {
  return ThemeData(

    primarySwatch: const MaterialColor(4286318110, {
      50: Color(0xfffee7eb),
      100: Color(0xfffdced8),
      200: Color(0xfffa9eb1),
      300: Color(0xfff86d89),
      400: Color(0xfff63c62),
      500: Color(0xfff30c3b),
      600: Color(0xffc3092f),
      700: Color(0xff920723),
      800: Color(0xff610518),
      900: Color(0xff31020c)
    }),
    brightness: Brightness.light,
    primaryColor: const Color(0xff7c061e),
    primaryColorLight: const Color(0xfffdced8),
    primaryColorDark: const Color(0xff920723),
    canvasColor: const Color(0xfffafafa),
    scaffoldBackgroundColor: const Color(0xfffafafa),
    bottomAppBarColor: const Color(0xffffffff),
    cardColor: const Color(0xffffffff),
    dividerColor: const Color(0x1f000000),
    highlightColor: const Color(0x66bcbcbc),
    splashColor: const Color(0x66c8c8c8),
    selectedRowColor: const Color(0xfff5f5f5),
    unselectedWidgetColor: const Color(0x8a000000),
    disabledColor: const Color(0x61000000),
    toggleableActiveColor: const Color(0xffc3092f),
    secondaryHeaderColor: const Color(0xfffee7eb),
    backgroundColor: const Color(0xfffa9eb1),
    dialogBackgroundColor: const Color(0xffffffff),
    indicatorColor: const Color(0xfff30c3b),
    hintColor: const Color(0x8a000000),
    errorColor: const Color(0xffd32f2f),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.normal,
      minWidth: 88,
      height: 36,
      padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xff000000),
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      alignedDropdown: false,
      buttonColor: Color(0xffe0e0e0),
      disabledColor: Color(0x61000000),
      highlightColor: Color(0x29000000),
      splashColor: Color(0x1f000000),
      focusColor: Color(0x1f000000),
      hoverColor: Color(0x0a000000),
      colorScheme: ColorScheme(
        primary: Color(0xff7c061e),
        secondary: Color(0xfff30c3b),
        surface: Color(0xffffffff),
        background: Color(0xfffa9eb1),
        error: Color(0xffd32f2f),
        onPrimary: Color(0xffffffff),
        onSecondary: Color(0xffffffff),
        onSurface: Color(0xff000000),
        onBackground: Color(0xffffffff),
        onError: Color(0xffffffff),
        brightness: Brightness.light,
      ),
    ),

    iconTheme: const IconThemeData(
      color: Color(0xdd000000),
      opacity: 1,
      size: 24,
    ),
    primaryIconTheme: const IconThemeData(
      color: Color(0xffffffff),
      opacity: 1,
      size: 24,
    ),
    tabBarTheme: const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Color(0xffffffff),
      unselectedLabelColor: Color(0xb2ffffff),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Color(0x1f000000),
      brightness: Brightness.light,
      deleteIconColor: Color(0xde000000),
      disabledColor: Color(0x0c000000),
      labelPadding: EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
      labelStyle: TextStyle(
        color: Color(0xde000000),
        fontSize: null,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
      secondaryLabelStyle: TextStyle(
        color: Color(0x3d000000),
        fontSize: null,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      secondarySelectedColor: Color(0x3d7c061e),
      selectedColor: Color(0x3d000000),
      shape: StadiumBorder(
          side: BorderSide(
        color: Color(0xff000000),
        width: 0,
        style: BorderStyle.none,
      )),
    ),
    dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
      side: BorderSide(
        color: Color(0xff000000),
        width: 0,
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
    )),
    appBarTheme: AppBarTheme(
        foregroundColor: const Color(0xFFfffafafb),
        backgroundColor: ColorManager.white,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorManager.black)),
    colorScheme: const ColorScheme(
      primary: Color(0xff7c061e),
      secondary: Color(0xfff30c3b),
      surface: Color(0xffffffff),
      background: Color(0xfffa9eb1),
      error: Color(0xffd32f2f),
      onPrimary: Color(0xffffffff),
      onSecondary: Color(0xffffffff),
      onSurface: Color(0xff000000),
      onBackground: Color(0xffffffff),
      onError: Color(0xffffffff),
      brightness: Brightness.light,
    ),
    applyElevationOverlayColor: false,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(/* ... */),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Color(0xFFfffafafb),
    ),
    focusColor: const Color(0xFF1f000000),
    hoverColor: const Color(0xFF0a000000),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shadowColor: const Color(0xFF000000),
    splashFactory: InkSplash.splashFactory,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(/* ... */),
    ),
    useMaterial3: false,
    visualDensity: VisualDensity.compact,
  );
}
