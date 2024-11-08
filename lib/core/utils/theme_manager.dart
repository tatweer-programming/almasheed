import 'package:flutter/material.dart';
import 'color_manager.dart';

ThemeData getAppTheme() {
  return ThemeData(
      useMaterial3: false,
      primarySwatch: const MaterialColor(4289493309, {
        50: Color(0xfff8f3ec),
        100: Color(0xfff2e6d9),
        200: Color(0xffe4ceb4),
        300: Color(0xffd7b58e),
        400: Color(0xffca9d68),
        500: Color(0xffbc8443),
        600: Color(0xff976a35),
        700: Color(0xff714f28),
        800: Color(0xff4b351b),
        900: Color(0xff261a0d)
      }),
      brightness: Brightness.light,
      primaryColor: const Color(0xffac793d),
      primaryColorLight: const Color(0xfff2e6d9),
      primaryColorDark: const Color(0xff714f28),
      canvasColor: const Color(0xfffafafa),
      scaffoldBackgroundColor: ColorManager.white,
      cardColor: const Color(0xffffffff),
      dividerColor: const Color(0x1f000000),
      highlightColor: const Color(0x66bcbcbc),
      splashColor: const Color(0x66c8c8c8),
      unselectedWidgetColor: const Color(0x8a000000),
      disabledColor: const Color(0x61000000),
      secondaryHeaderColor: const Color(0xfff8f3ec),
      dialogBackgroundColor: const Color(0xffffffff),
      indicatorColor: const Color(0xffbc8443),
      hintColor: const Color(0x8a000000),
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
        // colorScheme: ColorScheme(
        //   primary: Color(0xffac793d),
        //   secondary: Color(0xffbc8443),
        //   surface: Color(0xffffffff),
        //   error: Color(0xffd32f2f),
        //   onPrimary: Color(0xffffffff),
        //   onSecondary: Color(0xffffffff),
        //   onSurface: Color(0xff000000),
        //   onError: Color(0xffffffff),
        //   brightness: Brightness.light,
        // ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed, // Fixed
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: Color(0xdd000000),
          fontSize: null,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        helperStyle: TextStyle(
          color: Color(0xdd000000),
          fontSize: null,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        hintStyle: TextStyle(
          color: Color(0xdd000000),
          fontSize: null,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        errorStyle: TextStyle(
          color: Color(0xdd000000),
          fontSize: null,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        errorMaxLines: null,
        isDense: false,
        contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
        isCollapsed: false,
        prefixStyle: TextStyle(
          color: Color(0xdd000000),
          fontSize: null,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        suffixStyle: TextStyle(
          color: Color(0xdd000000),
          fontSize: null,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        counterStyle: TextStyle(
          color: Color(0xdd000000),
          fontSize: null,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        filled: false,
        fillColor: Color(0x00000000),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
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
      sliderTheme: const SliderThemeData(
        activeTrackColor: null,
        inactiveTrackColor: null,
        disabledActiveTrackColor: null,
        disabledInactiveTrackColor: null,
        activeTickMarkColor: null,
        inactiveTickMarkColor: null,
        disabledActiveTickMarkColor: null,
        disabledInactiveTickMarkColor: null,
        thumbColor: null,
        disabledThumbColor: null,
        overlayColor: null,
        valueIndicatorColor: null,
        showValueIndicator: null,
        valueIndicatorTextStyle: TextStyle(
          color: Color(0xffffffff),
          fontSize: null,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
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
        secondarySelectedColor: Color(0x3dac793d),
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
      )));
}
