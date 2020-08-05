import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String _idUsuario;
  String _email;
  String _senha;
  String _perfil;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idUsuario': this.idUsuario,
      'email': this.email,
      'perfil': this.perfil,
    };
    return map;
  }

  Usuario.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.idUsuario = documentSnapshot.documentID;
    this.email = documentSnapshot["email"];
    this.perfil = documentSnapshot["perfil"];
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get perfil => _perfil;

  set perfil(String value) {
    _perfil = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }
}
