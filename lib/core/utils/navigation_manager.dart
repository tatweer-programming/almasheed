import 'package:flutter/material.dart';

class NavigationManager {
  static void pushAndRemove(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => screen), (route) => false);
  }

  static void push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  static void pushPage(BuildContext context, Widget screen) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            // var begin = const Offset(-1.0, 0);
            // var end = const Offset(0, 0);
            // var tween = Tween(begin: begin,end: end);
            // var offsetAnimation = animation.drive(tween);
            // return SlideTransition(position: offsetAnimation,child: child,);
          },
        ));
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
