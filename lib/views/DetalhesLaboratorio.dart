import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/main.dart';
import 'package:infolab_app/models/Laboratorio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesLaboratorio extends StatefulWidget {
  Laboratorio laboratorio;
  DetalhesLaboratorio(this.laboratorio);

  @override
  _DetalhesLaboratorioState createState() => _DetalhesLaboratorioState();
}

class _DetalhesLaboratorioState extends State<DetalhesLaboratorio> {
  Laboratorio _laboratorio;

  File pdf;

  List<Widget> _getListaImagens() {
    List<String> listaUrlImagens = _laboratorio.fotos;
    return listaUrlImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(url), fit: BoxFit.fitWidth)),
      );
    }).toList();
  }

  baixaArquivo() async {
    _abrirSite(_laboratorio.pdf);
  }

  _enviarEmail(String email) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      print("Não foi possível abrir Email");
    }
  }

  _abrirSite(String site) async {
    if (await canLaunch(site)) {
      await launch(site);
    } else {
      print("Não foi possível abrir site");
    }
  }

  List<String> equipamentosList = [];

  @override
  void initState() {
    super.initState();
    _laboratorio = widget.laboratorio;
    equipamentosList = _laboratorio.equipamentos.contains("; ")
        ? _laboratorio.equipamentos.split('; ')
        : _laboratorio.equipamentos.split(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laboratório"),
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(
                height: 250,
                child: Carousel(
                  images: _getListaImagens(),
                  dotSize: 8,
                  dotBgColor: Colors.transparent,
                  dotColor: Colors.white,
                  autoplay: false,
                  dotIncreasedColor: temaPadrao.primaryColor,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${_laboratorio.nome}",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${_laboratorio.grandeArea}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${_laboratorio.area}",
                      style: TextStyle(fontSize: 18),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Atividades",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${_laboratorio.atividades}",
                      style: TextStyle(fontSize: 18),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Principais Equipamentos",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: equipamentosList.length,
                      itemBuilder: (_, index) {
                        return Text('- ' + equipamentosList[index],
                            style: TextStyle(fontSize: 15));
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Contato",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text(
                        "${_laboratorio.responsavel}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text(
                        "${_laboratorio.email}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Local",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text(
                        "Estado: ${_laboratorio.estado}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text(
                        "Cidade: ${_laboratorio.cidade}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text(
                        "Instituição: ${_laboratorio.instituto}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Campus ${_laboratorio.campus}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    if (_laboratorio.pdf != ".")
                      Padding(
                        padding: EdgeInsets.only(bottom: 70),
                        child: GestureDetector(
                            child: Text(
                              "Normas de Utilização",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.lightBlue),
                            ),
                            onTap: () {
                              baixaArquivo();
                            }),
                      ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 70),
                      child: GestureDetector(
                          child: Text(
                            (_laboratorio.site != null)
                                ? _laboratorio.site
                                : "",
                            style: TextStyle(
                                fontSize: 18, color: Colors.lightBlue),
                          ),
                          onTap: () {
                            _abrirSite(_laboratorio.site);
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              child: Container(
                child: Text(
                  "Entrar em Contato",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: temaPadrao.primaryColor,
                    borderRadius: BorderRadius.circular(30)),
              ),
              onTap: () {
                _enviarEmail(_laboratorio.email);
              },
            ),
          )
        ],
      ),
    );
  }
}
