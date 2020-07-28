import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Cidade.dart';
import 'package:infolab_app/views/widgets/ItemCidade.dart';

class Cidades extends StatefulWidget {
  @override
  _CidadesState createState() => _CidadesState();
}

class _CidadesState extends State<Cidades> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionarListenerCidades() async {
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db.collection("cidades").snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerCidades();
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
        title: Text('Cidades'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/nova-cidade');
        },
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
                    List<DocumentSnapshot> cidades =
                        querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = cidades[indice];
                    Cidade cidade =
                        Cidade.fromDocumentSnapshot(documentSnapshot);
                    return ItemCidade(
                      cidade: cidade,
                      onTapItem: () {
                        Navigator.pushNamed(context, "/nova-cidade",
                            arguments: cidade);
                      },
                      onPressedEdit: () {
                        Navigator.pushNamed(context, "/nova-cidade",
                            arguments: cidade);
                      },
                    );
                  });
          }
          return Container();
        },
      ),
    );
  }
}
