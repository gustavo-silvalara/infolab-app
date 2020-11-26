import 'package:flutter/material.dart';
import 'package:infolab_app/RouteGenerator.dart';
import 'package:infolab_app/views/Laboratorios.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff507F39),
  accentColor: Color(0xff507F39),
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
