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
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      case 'Usuários':
        Navigator.pushNamed(context, '/usuarios');
        break;
      case 'Áreas':
        Navigator.pushNamed(context, '/areas');
        break;
      case 'Cidades':
        Navigator.pushNamed(context, '/cidades');
        break;
      case 'Institutos':
        Navigator.pushNamed(context, '/institutos');
        break;
      case 'Campus':
        Navigator.pushNamed(context, '/campus');
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
    LocalStorage storage = new LocalStorage("infolab");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("email");

    Navigator.popAndPushNamed(context, '/login');
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    var perfilAtual = null;
    Firestore db = Firestore.instance;

    LocalStorage storage = new LocalStorage('infolab');
    // var email = await storage.getItem("email");

    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    print(email);
    if (usuarioLogado != null) {
      var docs = await db.collection("usuarios").getDocuments();
      docs.documents.forEach((element) {
        if (element["email"] == email) {
          perfilAtual = element["perfil"];
        }
      });
    }

    print(perfilAtual);

    itensMenu = usuarioLogado == null
        ? ['Entrar/Cadastrar']
        : perfilAtual == "ADM TI"
            ? [
                'Meus Laboratórios',
                'Áreas',
                'Cidades',
                'Institutos',
                'Campus',
                'Usuários',
                'Sair'
              ]
            : perfilAtual == "ADM Sistema"
                ? [
                    'Meus Laboratórios',
                    'Áreas',
                    'Cidades',
                    'Institutos',
                    'Campus',
                    'Sair'
                  ]
                : perfilAtual == "Resp. Instituto"
                    ? ['Meus Laboratórios', 'Cidades', 'Campus', 'Sair']
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
                        onChanged: (grandeArea) {
                          setState(() {
                            _itemSelecionadoCategoria = grandeArea;
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
                    List<DocumentSnapshot> documentos =
                        new List<DocumentSnapshot>();
                    QuerySnapshot querySnapshot = snapshot.data;
                    if (_controllerPesquisa.text.length >= 2) {
                      querySnapshot.documents.forEach((element) {
                        Laboratorio laboratorio =
                            Laboratorio.fromDocumentSnapshot(element);
                        if (laboratorio.filtro != null &&
                            laboratorio.filtro
                                .contains(_controllerPesquisa.text)) {
                          documentos.add(element);
                        }
                      });
                    } else {
                      documentos = querySnapshot.documents;
                    }
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
                          itemCount: documentos.length,
                          itemBuilder: (_, indice) {
                            List<DocumentSnapshot> laboratorios =
                                documentos.toList();
                            DocumentSnapshot documentSnapshot =
                                laboratorios[indice];
                            Laboratorio laboratorio =
                                Laboratorio.fromDocumentSnapshot(
                                    documentSnapshot);
                            return ItemLaboratorio(
                              laboratorio: laboratorio,
                              onTapItem: () {
                                Navigator.pushNamed(
                                    context, "/detalhes-laboratorio",
                                    arguments: laboratorio);
                              },
                            );
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
