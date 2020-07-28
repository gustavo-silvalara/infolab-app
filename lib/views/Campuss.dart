import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Campus.dart';
import 'package:infolab_app/views/widgets/ItemCampus.dart';

class Campuss extends StatefulWidget {
  @override
  _CampussState createState() => _CampussState();
}

class _CampussState extends State<Campuss> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionarListenerCampus() async {
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db.collection("campus").snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerCampus();
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
        title: Text('Campus'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/novo-campus');
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
                    List<DocumentSnapshot> campuss =
                        querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = campuss[indice];
                    Campus campus =
                        Campus.fromDocumentSnapshot(documentSnapshot);
                    return ItemCampus(
                      campus: campus,
                      onTapItem: () {
                        Navigator.pushNamed(context, "/novo-campus",
                            arguments: campus);
                      },
                      onPressedEdit: () {
                        Navigator.pushNamed(context, "/novo-campus",
                            arguments: campus);
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
