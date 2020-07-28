import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Area.dart';
import 'package:infolab_app/views/widgets/ItemArea.dart';

class Areas extends StatefulWidget {
  @override
  _AreasState createState() => _AreasState();
}

class _AreasState extends State<Areas> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionarListenerAreas() async {
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db.collection("areas").snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAreas();
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
        title: Text('Areas'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/nova-area');
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
                    List<DocumentSnapshot> areas =
                        querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = areas[indice];
                    Area area = Area.fromDocumentSnapshot(documentSnapshot);
                    return ItemArea(
                      area: area,
                      onTapItem: () {
                        Navigator.pushNamed(context, "/nova-area",
                            arguments: area);
                      },
                      onPressedEdit: () {
                        Navigator.pushNamed(context, "/nova-area",
                            arguments: area);
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
