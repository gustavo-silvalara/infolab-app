import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Configuracoes {
  static String EMAIL_LOGADO = "";

  static List<DropdownMenuItem<String>> getEstados() {
    List<DropdownMenuItem<String>> listaItensDropEstados = [];

    //Categorias
    listaItensDropEstados.add(DropdownMenuItem(
      child: Text(
        "Estado",
        style: TextStyle(color: Color(0xff359830)),
      ),
      value: null,
    ));

    for (var estado in Estados.listaEstadosAbrv) {
      listaItensDropEstados.add(DropdownMenuItem(
        child: Text(estado),
        value: estado,
      ));
    }

    return listaItensDropEstados;
  }

  static List<DropdownMenuItem<String>> getCategorias() {
    List<DropdownMenuItem<String>> itensDropCategorias = [];

    //Categorias
    itensDropCategorias.add(DropdownMenuItem(
      child: Text(
        "Grande Área",
        style: TextStyle(color: Color(0xff359830)),
      ),
      value: null,
    ));

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Ciências Exatas e da Terra"),
      value: "exatas",
    ));

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Ciências Biológicas"),
      value: "biologicas",
    ));

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Engenharias"),
      value: "engenharias",
    ));

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Ciências da Saúde"),
      value: "saude",
    ));

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Ciências Agrárias"),
      value: "agrarias",
    ));

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Ciências Sociais"),
      value: "sociais",
    ));

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Ciências Humanas"),
      value: "humanas",
    ));

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Linguística, Letras e Artes"),
      value: "letras",
    ));

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Outros"),
      value: "outros",
    ));

    return itensDropCategorias;
  }

  static List<DropdownMenuItem<String>> getPerfis() {
    List<DropdownMenuItem<String>> itensDropPerfis = [];

    //Categorias
    itensDropPerfis.add(DropdownMenuItem(
      child: Text(
        "Perfis",
        style: TextStyle(color: Color(0xff359830)),
      ),
      value: null,
    ));

    itensDropPerfis.add(DropdownMenuItem(
      child: Text("ADM TI"),
      value: "ADM TI",
    ));

    itensDropPerfis.add(DropdownMenuItem(
      child: Text("ADM Sistema"),
      value: "ADM Sistema",
    ));

    itensDropPerfis.add(DropdownMenuItem(
      child: Text("Resp. Institucional"),
      value: "Resp. Institucional",
    ));

    itensDropPerfis.add(DropdownMenuItem(
      child: Text("Resp. Laboratório"),
      value: "Resp. Laboratório",
    ));

    return itensDropPerfis;
  }
}
