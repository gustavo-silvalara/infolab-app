import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infolab_app/models/Laboratorio.dart';
import 'package:infolab_app/views/widgets/ItemLaboratorio.dart';

class Laboratorios extends StatefulWidget {
  @override
  _LaboratoriosState createState() => _LaboratoriosState();
}

class _LaboratoriosState extends State<Laboratorios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  String _idUsuarioLogado;

  _recuperaDadosUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {
    await _recuperaDadosUsuarioLogado();

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection('meus_laboratorios')
        // .document(_idUsuarioLogado)
        // .collection('laboratorios')
        // no firebase a ordem tem que ser pasta meus_laboratorios/ pasta com id do usuario/ pasta laboratorios
        .snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
    _verificarUsuarioLogado();
  }

  List<String> itensMenu = [];

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
        title: Text('Laboratórios'),
        elevation: 0,
        actions: <Widget>[
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
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Erro ao carregar os dados!');

              QuerySnapshot querySnapshot = snapshot.data;
              return ListView.builder(
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (_, indice) {
                    List<DocumentSnapshot> laboratorios =
                        querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = laboratorios[indice];
                    Laboratorio laboratorio =
                        Laboratorio.fromDocumentSnapshot(documentSnapshot);
                    return ItemLaboratorio(
                      laboratorio: laboratorio,
                    );
                  });
          }
          return Container();
        },
      ),
    );
  }
}
