import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Usuario.dart';
import 'package:infolab_app/views/widgets/ItemUsuario.dart';
// import 'package:firebase_admin/firebase_admin.dart';
// import 'package:firebase_admin/src/credential.dart';

class Usuarioss extends StatefulWidget {
  @override
  _UsuariossState createState() => _UsuariossState();
}

class _UsuariossState extends State<Usuarioss> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionarListenerUsuarios() async {
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db.collection("usuarios").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerUsuarios();
  }

  deletarUsuario(String uid) async {
    // var credential = Credentials.applicationDefault();
    // credential ??= await Credentials.login();

    // var app = FirebaseAdmin.instance.initializeApp(AppOptions(
    //     credential: credential ?? Credentials.applicationDefault(),
    //     projectId: 'infolab'));
    // app.auth().deleteUser(uid);
    // Firestore db = Firestore.instance;
    // db.collection("usuarios").document(uid).delete();
  }

  void _showDialogConfirma(String uid) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Remover Usuário?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Não"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Sim"),
              onPressed: () async {
                await deletarUsuario(uid);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        title: Text('Usuários'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/novo-usuario');
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
                    Usuario usuario =
                        Usuario.fromDocumentSnapshot(documentSnapshot);
                    return ItemUsuario(
                      usuario: usuario,
                      // onPressedEdit: () {
                      //   _showDialogConfirma(usuario.idUsuario);
                      // },
                    );
                  });
          }
          return Container();
        },
      ),
    );
  }
}
