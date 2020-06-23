import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/views/DetalhesLaboratorio.dart';
import 'package:infolab_app/views/Laboratorios.dart';
import 'package:infolab_app/views/Login.dart';
import 'package:infolab_app/views/MeusLaboratorios.dart';
import 'package:infolab_app/views/NovoLaboratorio.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Laboratorios(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
      case '/meus-laboratorios':
        return MaterialPageRoute(
          builder: (_) => MeusLaboratorios(),
        );
      case '/novo-laboratorio':
        return MaterialPageRoute(
          builder: (_) => NovoLaboratorio(),
        );
      case "/detalhes-laboratorio":
        return MaterialPageRoute(builder: (_) => DetalhesLaboratorio(args));
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Tela não encontrada!'),
        ),
        body: Center(
          child: Text('Tela não encontrada!'),
        ),
      );
    });
  }
}
