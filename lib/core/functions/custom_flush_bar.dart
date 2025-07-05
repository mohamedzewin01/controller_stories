import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> customFlushBar(
  BuildContext context, {
  required String message,
  required String title,
  Color? color,
  Widget? icon,
}) async {
  Flushbar(
    title: title,
    message: message,
    backgroundColor: color ?? Colors.green,
    icon: icon,
    duration: Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,

    boxShadows: [
      BoxShadow(color: Colors.black, offset: Offset(0.0, 2.0), blurRadius: 3.0),
    ],
  ).show(context);
}
