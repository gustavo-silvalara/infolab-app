import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/views/Areas.dart';
import 'package:infolab_app/views/Campuss.dart';
import 'package:infolab_app/views/Cidades.dart';
import 'package:infolab_app/views/DetalhesLaboratorio.dart';
import 'package:infolab_app/views/Institutos.dart';
import 'package:infolab_app/views/Laboratorios.dart';
import 'package:infolab_app/views/Login.dart';
import 'package:infolab_app/views/MeusLaboratorios.dart';
import 'package:infolab_app/views/NovaArea.dart';
import 'package:infolab_app/views/NovaCidade.dart';
import 'package:infolab_app/views/NovoCampus.dart';
import 'package:infolab_app/views/NovoInstituto.dart';
import 'package:infolab_app/views/NovoLaboratorio.dart';
import 'package:infolab_app/views/NovoUsuario.dart';

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
      case '/novo-usuario':
        return MaterialPageRoute(
          builder: (_) => NovoUsuario(),
        );
      case '/novo-laboratorio':
        return MaterialPageRoute(
          builder: (_) => NovoLaboratorio(args),
        );
      case '/cidades':
        return MaterialPageRoute(
          builder: (_) => Cidades(),
        );
      case '/nova-cidade':
        return MaterialPageRoute(
          builder: (_) => NovaCidade(args),
        );
      case '/institutos':
        return MaterialPageRoute(
          builder: (_) => Institutos(),
        );
      case '/novo-instituto':
        return MaterialPageRoute(
          builder: (_) => NovoInstituto(args),
        );
      case '/campus':
        return MaterialPageRoute(
          builder: (_) => Campuss(),
        );
      case '/novo-campus':
        return MaterialPageRoute(
          builder: (_) => NovoCampus(args),
        );
      case '/areas':
        return MaterialPageRoute(
          builder: (_) => Areas(),
        );
      case '/nova-area':
        return MaterialPageRoute(
          builder: (_) => NovaArea(args),
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
