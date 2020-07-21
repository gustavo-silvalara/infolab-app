import 'package:cloud_firestore/cloud_firestore.dart';

class Instituto {
  String _id;
  String _estado;
  String _nome;

  Instituto();

  Instituto.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.documentID;
    this.estado = documentSnapshot["estado"];
    this.nome = documentSnapshot["nome"];
  }

  Instituto.gerarId() {
    Firestore db = Firestore.instance;
    CollectionReference institutos = db.collection("institutos");
    this.id = institutos.document().documentID;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "estado": this.estado,
      "nome": this.nome,
    };

    return map;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
