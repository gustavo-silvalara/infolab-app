import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  String _id;
  String _grandeArea;
  String _nome;

  Area();

  Area.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.documentID;
    this.grandeArea = documentSnapshot["grandeArea"];
    this.nome = documentSnapshot["nome"];
  }

  Area.gerarId() {
    Firestore db = Firestore.instance;
    CollectionReference institutos = db.collection("areas");
    this.id = institutos.document().documentID;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "grandeArea": this.grandeArea,
      "nome": this.nome,
    };

    return map;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get grandeArea => _grandeArea;

  set grandeArea(String value) {
    _grandeArea = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
