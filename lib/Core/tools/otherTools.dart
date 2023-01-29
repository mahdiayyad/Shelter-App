
import 'dart:ui';

/// delay a screen 500 miliseconds
void postDelayed({int milliseconds = 500, required VoidCallback callbak}) {
  Future.delayed(Duration(milliseconds: milliseconds), () {
    callbak();
  });
}