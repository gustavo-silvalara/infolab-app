import 'package:cloud_firestore/cloud_firestore.dart';

class Laboratorio {
  String _id;
  String _estado;
  String _categoria;
  String _nome;
  String _responsavel;
  String _email;
  String _descricao;
  List<String> _fotos;

  Laboratorio();

  Laboratorio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.documentID;
    this.estado = documentSnapshot["estado"];
    this.categoria = documentSnapshot["categoria"];
    this.nome = documentSnapshot["nome"];
    this.responsavel = documentSnapshot["responsavel"];
    this.email = documentSnapshot["email"];
    this.descricao = documentSnapshot["descricao"];
    this.fotos = List<String>.from(documentSnapshot["fotos"]);
  }

  Laboratorio.gerarId() {
    Firestore db = Firestore.instance;
    CollectionReference laboratorios = db.collection("meus_laboratorios");
    this.id = laboratorios.document().documentID;
    this.fotos = [];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "estado": this.estado,
      "categoria": this.categoria,
      "nome": this.nome,
      "responsavel": this.responsavel,
      "email": this.email,
      "descricao": this.descricao,
      "fotos": this.fotos,
    };

    return map;
  }

  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get responsavel => _responsavel;

  set responsavel(String value) {
    _responsavel = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
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
