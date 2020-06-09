import 'package:flutter/material.dart';
import 'package:infolab_app/views/Home.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff359830),
  accentColor: Color(0xff287224),
  backgroundColor: Colors.white,
);

void main() {
  runApp(MaterialApp(
    title: "InfoLab",
    home: Home(),
    theme: temaPadrao,
    debugShowCheckedModeBanner: false,
  ));
}
