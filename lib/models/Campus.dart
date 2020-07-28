import 'package:cloud_firestore/cloud_firestore.dart';

class Campus {
  String _id;
  String _estado;
  String _cidade;
  String _nome;

  Campus();

  Campus.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.documentID;
    this.estado = documentSnapshot["estado"];
    this.cidade = documentSnapshot["cidade"];
    this.nome = documentSnapshot["nome"];
  }

  Campus.gerarId() {
    Firestore db = Firestore.instance;
    CollectionReference institutos = db.collection("campus");
    this.id = institutos.document().documentID;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "estado": this.estado,
      "nome": this.nome,
      "cidade": this.cidade,
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

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }
}
