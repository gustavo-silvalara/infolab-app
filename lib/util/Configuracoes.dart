import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes {
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
        "Área",
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
      value: "engenharia",
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
}
