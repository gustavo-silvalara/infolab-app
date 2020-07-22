import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infolab_app/main.dart';
import 'package:infolab_app/models/Area.dart';
import 'package:infolab_app/models/Campus.dart';
import 'package:infolab_app/models/Cidade.dart';
import 'package:infolab_app/models/Instituto.dart';
import 'package:infolab_app/models/Laboratorio.dart';
import 'package:infolab_app/util/Configuracoes.dart';
import 'package:infolab_app/views/widgets/BotaoCustomizado.dart';
import 'package:infolab_app/views/widgets/CustomInput.dart';
import 'package:validadores/Validador.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class NovoLaboratorio extends StatefulWidget {
  @override
  _NovoLaboratorioState createState() => _NovoLaboratorioState();
}

class _NovoLaboratorioState extends State<NovoLaboratorio> {
  List<File> _listaImagens = List();
  List<DropdownMenuItem<String>> _listaItensDropEstados = List();
  List<DropdownMenuItem<String>> _listaItensDropCategorias = List();
  final _formKey = GlobalKey<FormState>();
  Laboratorio _laboratorio;
  BuildContext _dialogContext;

  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;

  Map<String, String> grandesAreas = new Map();

  _selecionarImagemGaleria(int imageSource) async {
    File imagemSelecionada = await ImagePicker.pickImage(
        source: imageSource == 0 ? ImageSource.camera : ImageSource.gallery);

    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text("Salvando Laboratório...")
              ],
            ),
          );
        });
  }

  void _modalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Câmera'),
                    onTap: () {
                      _selecionarImagemGaleria(0);
                    }),
                ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Galeria'),
                  onTap: () {
                    _selecionarImagemGaleria(1);
                  },
                ),
              ],
            ),
          );
        });
  }

  _salvarLaboratorio() async {
    _abrirDialog(_dialogContext);

    //Upload imagens no Storage
    await _uploadImagens();

    //Salvar lab no Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;

    _laboratorio.filtro = _laboratorio.nome +
        ' ' +
        _laboratorio.responsavel +
        ' ' +
        _laboratorio.email +
        ' ' +
        _laboratorio.equipamentos +
        ' ' +
        _laboratorio.atividades +
        ' ' +
        _laboratorio.estado +
        ' ' +
        _laboratorio.cidade +
        ' ' +
        _laboratorio.instituto +
        ' ' +
        _laboratorio.grandeArea +
        ' ' +
        _laboratorio.campus +
        ' ' +
        _laboratorio.area +
        ' ' +
        _laboratorio.categoria;

    db
        .collection("laboratorios")
        .document(_laboratorio.id)
        .setData(_laboratorio.toMap())
        .then((_) {
      db
          .collection("meus_laboratorios")
          .document(idUsuarioLogado)
          .collection("laboratorios")
          .document(_laboratorio.id)
          .setData(_laboratorio.toMap())
          .then((_) {
        Navigator.pop(_dialogContext);
        Navigator.pop(context);
      });
    });
  }

  _salvarInstituto(Instituto instituto) async {
    Firestore db = Firestore.instance;
    if (_itemSelecionadoEstado != null &&
        instituto != null &&
        (instituto.nome.isNotEmpty)) {
      db
          .collection("institutos")
          .document(instituto.id)
          .setData(instituto.toMap());
    }
  }

  _salvarCidade(Cidade cidade) async {
    Firestore db = Firestore.instance;
    if (_itemSelecionadoEstado != null &&
        cidade != null &&
        (cidade.nome.isNotEmpty)) {
      db.collection("cidades").document(cidade.id).setData(cidade.toMap());
    }
  }

  _salvarCampus(Campus campus) async {
    Firestore db = Firestore.instance;
    if (_itemSelecionadoEstado != null &&
        campus != null &&
        (campus.nome.isNotEmpty)) {
      db.collection("campus").document(campus.id).setData(campus.toMap());
    }
  }

  _salvarArea(Area area) async {
    Firestore db = Firestore.instance;
    if (_itemSelecionadoCategoria != null &&
        area != null &&
        (area.nome.isNotEmpty)) {
      db.collection("areas").document(area.id).setData(area.toMap());
    }
  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();

    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference arquivo = pastaRaiz
          .child("meus_laboratorios")
          .child(_laboratorio.id)
          .child(nomeImagem);

      StorageUploadTask uploadTask = arquivo.putFile(imagem);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      String url = await taskSnapshot.ref.getDownloadURL();
      _laboratorio.fotos.add(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    this.grandesAreas = {
      'exatas': "Ciências Exatas e da Terra",
      'biologicas': "Ciências Biológicas",
      'engenharias': "Engenharias",
      "saude": "Ciências da Saúde",
      "agrarias": "Ciências Agrárias",
      "sociais": "Ciências Sociais",
      "humanas": "Ciências Humanas",
      "letras": "Linguística, Letras e Artes",
      "outros": "Outros"
    };
    _laboratorio = Laboratorio.gerarId();
  }

  _carregarItensDropdown() {
    //Categorias
    _listaItensDropCategorias = Configuracoes.getCategorias();

    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  Future<List<dynamic>> getSuggestionInstituto(String suggestion) async {
    Firestore db = Firestore.instance;
    var querySnap = await db.collection("institutos").getDocuments();
    var docs = [];
    if (_itemSelecionadoEstado != null) {
      querySnap.documents.forEach((e) => {
            if (e.data['estado'] == _itemSelecionadoEstado &&
                e.data['nome'].contains(suggestion))
              docs.add(e)
          });
    }
    return docs;
  }

  Future<List<dynamic>> getSuggestionCidades(String suggestion) async {
    Firestore db = Firestore.instance;
    var querySnap = await db.collection("cidades").getDocuments();
    var docs = [];
    if (_itemSelecionadoEstado != null) {
      querySnap.documents.forEach((e) => {
            if (e.data['estado'] == _itemSelecionadoEstado &&
                e.data['nome'].contains(suggestion))
              docs.add(e)
          });
    }
    return docs;
  }

  Future<List<dynamic>> getSuggestionCampus(String suggestion) async {
    Firestore db = Firestore.instance;
    var querySnap = await db.collection("campus").getDocuments();
    var docs = [];
    if (_itemSelecionadoEstado != null) {
      querySnap.documents.forEach((e) => {
            if (e.data['estado'] == _itemSelecionadoEstado &&
                e.data['nome'].contains(suggestion))
              docs.add(e)
          });
    }
    return docs;
  }

  Future<List<dynamic>> getSuggestionArea(String suggestion) async {
    Firestore db = Firestore.instance;
    var querySnap = await db.collection("areas").getDocuments();
    var docs = [];
    if (_itemSelecionadoCategoria != null) {
      querySnap.documents.forEach((e) => {
            if (e.data['grandeArea'] == _itemSelecionadoCategoria &&
                e.data['nome'].contains(suggestion))
              docs.add(e)
          });
    }
    return docs;
  }

  final TextEditingController _typeAheadInstitutoController =
      TextEditingController();
  final TextEditingController _typeAheadCidadeController =
      TextEditingController();
  final TextEditingController _typeAheadCampusController =
      TextEditingController();
  final TextEditingController _typeAheadAreaController =
      TextEditingController();

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Laboratório"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens.length == 0) {
                      return "Selecione pelo menos 1 imagem!";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length + 1, //3
                              itemBuilder: (context, indice) {
                                if (indice == _listaImagens.length) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _modalBottomSheet(context);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                  color: Colors.grey[100]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                if (_listaImagens.length > 0) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Image.file(_listaImagens[
                                                          indice]),
                                                      FlatButton(
                                                        child: Text("Excluir"),
                                                        textColor: Colors.red,
                                                        onPressed: () {
                                                          setState(() {
                                                            _listaImagens
                                                                .removeAt(
                                                                    indice);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            FileImage(_listaImagens[indice]),
                                        child: Container(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          )
                      ],
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomInput(
                    hint: "Nome*",
                    onSaved: (nome) {
                      _laboratorio.nome = nome;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomInput(
                    hint: "Responsável*",
                    onSaved: (responsavel) {
                      _laboratorio.responsavel = responsavel;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomInput(
                    hint: "Email*",
                    onSaved: (email) {
                      _laboratorio.email = email;
                    },
                    type: TextInputType.emailAddress,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: CustomInput(
                    hint: "Atividades*",
                    onSaved: (atividades) {
                      _laboratorio.atividades = atividades;
                    },
                    maxLines: 3,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: CustomInput(
                    hint: "Equipamentos*",
                    onSaved: (equipamentos) {
                      _laboratorio.equipamentos = equipamentos;
                    },
                    maxLines: 3,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomInput(
                    hint: "Site",
                    onSaved: (site) {
                      _laboratorio.site = site;
                    },
                    type: TextInputType.text,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEstado,
                          hint: Text("Estados"),
                          onSaved: (estado) {
                            print(estado);
                            _laboratorio.estado = estado;
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaItensDropEstados,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoEstado = valor;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          value: _itemSelecionadoCategoria,
                          hint: Text("Categorias"),
                          onSaved: (grandeArea) {
                            _laboratorio.grandeArea =
                                this.grandesAreas[grandeArea];
                            _laboratorio.categoria = grandeArea;
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaItensDropCategorias,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoCategoria = valor;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: TypeAheadField(
                    noItemsFoundBuilder: (context) {
                      return RaisedButton(
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        disabledTextColor: Colors.transparent,
                        elevation: 0.0,
                        child: Text(
                          "Adicionar " +
                              this._typeAheadInstitutoController.text,
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.transparent),
                        ),
                        onPressed: () {
                          if (_itemSelecionadoEstado != null) {
                            Instituto instituto = Instituto.gerarId();
                            instituto.estado = _itemSelecionadoEstado;
                            instituto.nome = _laboratorio.instituto;
                            _salvarInstituto(instituto);
                            FocusScope.of(context).requestFocus(focus);
                          }
                        },
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(fontSize: 20),
                      onTap: () {
                        this._typeAheadInstitutoController.text = "";
                      },
                      controller: this._typeAheadInstitutoController,
                      onChanged: (instituto) {
                        _laboratorio.instituto = instituto;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          border: OutlineInputBorder(),
                          hintText: "Instituto*"),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await getSuggestionInstituto(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion['nome']),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _laboratorio.instituto = suggestion['nome'];
                      if (_itemSelecionadoEstado != null) {
                        this._typeAheadInstitutoController.text =
                            suggestion['nome'];
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: TypeAheadField(
                    noItemsFoundBuilder: (context) {
                      return RaisedButton(
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        disabledTextColor: Colors.transparent,
                        elevation: 0.0,
                        child: Text(
                          "Adicionar " + this._typeAheadCidadeController.text,
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.transparent),
                        ),
                        onPressed: () {
                          if (_itemSelecionadoEstado != null) {
                            Cidade cidade = Cidade.gerarId();
                            cidade.estado = _itemSelecionadoEstado;
                            cidade.nome = _laboratorio.cidade;
                            _salvarCidade(cidade);
                            FocusScope.of(context).requestFocus(focus);
                          }
                        },
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(fontSize: 20),
                      onTap: () {
                        this._typeAheadCidadeController.text = "";
                      },
                      controller: this._typeAheadCidadeController,
                      onChanged: (_) {
                        _laboratorio.cidade =
                            this._typeAheadCidadeController.text;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          border: OutlineInputBorder(),
                          hintText: "Cidade*"),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await getSuggestionCidades(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion['nome']),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _laboratorio.cidade = suggestion['nome'];
                      if (_itemSelecionadoEstado != null) {
                        this._typeAheadCidadeController.text =
                            suggestion['nome'];
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: TypeAheadField(
                    noItemsFoundBuilder: (context) {
                      return RaisedButton(
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        disabledTextColor: Colors.transparent,
                        elevation: 0.0,
                        child: Text(
                          "Adicionar " + this._typeAheadCampusController.text,
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.transparent),
                        ),
                        onPressed: () {
                          if (_itemSelecionadoEstado != null) {
                            Campus campus = Campus.gerarId();
                            campus.estado = _itemSelecionadoEstado;
                            campus.nome = _laboratorio.campus;
                            _salvarCampus(campus);
                            FocusScope.of(context).requestFocus(focus);
                          }
                        },
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(fontSize: 20),
                      onTap: () {
                        this._typeAheadCampusController.text = "";
                      },
                      controller: this._typeAheadCampusController,
                      onChanged: (_) {
                        _laboratorio.campus =
                            this._typeAheadCampusController.text;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          border: OutlineInputBorder(),
                          hintText: "Campus*"),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await getSuggestionCampus(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion['nome']),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _laboratorio.campus = suggestion['nome'];
                      if (_itemSelecionadoEstado != null) {
                        this._typeAheadCampusController.text =
                            suggestion['nome'];
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: TypeAheadField(
                    noItemsFoundBuilder: (context) {
                      return RaisedButton(
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        disabledTextColor: Colors.transparent,
                        elevation: 0.0,
                        child: Text(
                          "Adicionar " + this._typeAheadAreaController.text,
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.transparent),
                        ),
                        onPressed: () {
                          if (_itemSelecionadoCategoria != null) {
                            Area area = Area.gerarId();
                            area.grandeArea = _itemSelecionadoCategoria;
                            area.nome = _laboratorio.area;
                            _salvarArea(area);
                            FocusScope.of(context).requestFocus(focus);
                          }
                        },
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      onTap: () {
                        this._typeAheadAreaController.text = "";
                      },
                      controller: this._typeAheadAreaController,
                      onChanged: (_) {
                        _laboratorio.area = this._typeAheadAreaController.text;
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          border: OutlineInputBorder(),
                          hintText: "Área*"),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await getSuggestionArea(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion['nome']),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _laboratorio.area = suggestion['nome'];
                      if (_itemSelecionadoCategoria != null) {
                        this._typeAheadAreaController.text = suggestion['nome'];
                      }
                    },
                  ),
                ),
                BotaoCustomizado(
                  texto: "Cadastrar Laboratório",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //salva campos
                      _formKey.currentState.save();

                      //Configura dialog context
                      _dialogContext = context;

                      //salvar lab
                      _salvarLaboratorio();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
