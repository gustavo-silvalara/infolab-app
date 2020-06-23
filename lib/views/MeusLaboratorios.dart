import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Laboratorio.dart';
import 'package:infolab_app/views/widgets/ItemLaboratorio.dart';

class MeusLaboratorios extends StatefulWidget {
  @override
  _MeusLaboratoriosState createState() => _MeusLaboratoriosState();
}

class _MeusLaboratoriosState extends State<MeusLaboratorios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado;

  _recuperaDadosUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerLaboratorios() async {
    await _recuperaDadosUsuarioLogado();

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream =
        db.collection('meus_laboratorios').snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
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
        title: Text('Meus Laboratórios'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/novo-laboratorio');
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
                    List<DocumentSnapshot> laboratorios =
                        querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = laboratorios[indice];
                    Laboratorio laboratorio =
                        Laboratorio.fromDocumentSnapshot(documentSnapshot);
                    return ItemLaboratorio(
                      laboratorio: laboratorio,
                      onPressedEdit: () {
                        Navigator.pushNamed(context, "/detalhes-laboratorio",
                            arguments: laboratorio);
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
