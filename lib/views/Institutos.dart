import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Instituto.dart';
import 'package:infolab_app/views/widgets/ItemInstituto.dart';

class Institutos extends StatefulWidget {
  @override
  _InstitutosState createState() => _InstitutosState();
}

class _InstitutosState extends State<Institutos> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionarListenerInstitutos() async {
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db.collection("institutos").snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerInstitutos();
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
        title: Text('Institutos'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/novo-instituto');
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
                    List<DocumentSnapshot> institutos =
                        querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = institutos[indice];
                    Instituto instituto =
                        Instituto.fromDocumentSnapshot(documentSnapshot);
                    return ItemInstituto(
                      instituto: instituto,
                      onTapItem: () {
                        Navigator.pushNamed(context, "/novo-instituto",
                            arguments: instituto);
                      },
                      onPressedEdit: () {
                        Navigator.pushNamed(context, "/novo-instituto",
                            arguments: instituto);
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
