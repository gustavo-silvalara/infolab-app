import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infolab_app/main.dart';
import 'package:infolab_app/models/Laboratorio.dart';
import 'package:infolab_app/util/Configuracoes.dart';
import 'package:infolab_app/views/widgets/InputPesquisa.dart';
import 'package:infolab_app/views/widgets/ItemLaboratorio.dart';

class Laboratorios extends StatefulWidget {
  @override
  _LaboratoriosState createState() => _LaboratoriosState();
}

class _LaboratoriosState extends State<Laboratorios> {
  bool digitando = false;
  final TextEditingController _controllerPesquisa =
      TextEditingController(text: '');

  List<String> itensMenu = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias;
  List<DropdownMenuItem<String>> _listaItensDropEstados;

  final _controller = StreamController<QuerySnapshot>.broadcast();

  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case 'Meus Laboratórios':
        Navigator.pushNamed(context, '/meus-laboratorios');
        break;
      case 'Entrar/Cadastrar':
        Navigator.pushReplacementNamed(context, '/login');
        break;
      case 'Sair':
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.popAndPushNamed(context, '/login');
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    itensMenu = usuarioLogado == null
        ? ['Entrar/Cadastrar']
        : ['Meus Laboratórios', 'Sair'];
  }

  _carregarItensDropdown() {
    //Categorias
    _listaItensDropCategorias = Configuracoes.getCategorias();

    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerLaboratorios() async {
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db.collection("laboratorios").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _filtrarLaboratorios() async {
    this.filtro = false;
    Firestore db = Firestore.instance;
    Query query = db.collection("laboratorios");

    if (_itemSelecionadoEstado != null) {
      query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }
    if (_itemSelecionadoCategoria != null) {
      query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _filtrarPesquisa() async {
    this.filtro = true;
    Firestore db = Firestore.instance;
    Query query = db.collection("laboratorios");

    query = query.orderBy("filtro");

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  bool filtro = false;

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _verificarUsuarioLogado();
    _adicionarListenerLaboratorios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: digitando
            ? InputPesquisa(
                controller: _controllerPesquisa,
                onTyping: this._filtrarPesquisa,
              )
            : Text('Laboratórios'),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(digitando ? Icons.check : Icons.search),
            onPressed: () {
              setState(() {
                if (digitando) {
                  _filtrarPesquisa();
                }
                digitando = !digitando;
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: temaPadrao.primaryColor,
                        value: _itemSelecionadoEstado,
                        items: _listaItensDropEstados,
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        onChanged: (estado) {
                          setState(() {
                            _itemSelecionadoEstado = estado;
                            _filtrarLaboratorios();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: temaPadrao.primaryColor,
                        value: _itemSelecionadoCategoria,
                        items: _listaItensDropCategorias,
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        onChanged: (categoria) {
                          setState(() {
                            _itemSelecionadoCategoria = categoria;
                            _filtrarLaboratorios();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return carregandoDados;
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot = snapshot.data;
                    if (querySnapshot.documents.length == 0) {
                      return Container(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "Nenhum Laboratório!",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                          itemCount: querySnapshot.documents.length,
                          itemBuilder: (_, indice) {
                            List<DocumentSnapshot> laboratorios =
                                querySnapshot.documents.toList();
                            DocumentSnapshot documentSnapshot =
                                laboratorios[indice];
                            Laboratorio laboratorio =
                                Laboratorio.fromDocumentSnapshot(
                                    documentSnapshot);
                            if (_controllerPesquisa.text.length < 2) {
                              return ItemLaboratorio(
                                laboratorio: laboratorio,
                                onTapItem: () {
                                  Navigator.pushNamed(
                                      context, "/detalhes-laboratorio",
                                      arguments: laboratorio);
                                },
                              );
                            } else {
                              if (laboratorio.filtro.toUpperCase().contains(
                                  _controllerPesquisa.text.toUpperCase())) {
                                return ItemLaboratorio(
                                  laboratorio: laboratorio,
                                  onTapItem: () {
                                    Navigator.pushNamed(
                                        context, "/detalhes-laboratorio",
                                        arguments: laboratorio);
                                  },
                                );
                              }
                            }
                          }),
                    );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
