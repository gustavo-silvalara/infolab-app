import 'package:flutter/material.dart';
import 'package:infolab_app/RouteGenerator.dart';
import 'package:infolab_app/views/Laboratorios.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff359830),
  accentColor: Color(0xff287224),
  backgroundColor: Colors.white,
);

void main() {
  runApp(MaterialApp(
    title: 'InfoLab',
    home: Laboratorios(),
    theme: temaPadrao,
    initialRoute: '/',
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
