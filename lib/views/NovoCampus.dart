import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:infolab_app/models/Campus.dart';
import 'package:infolab_app/models/Cidade.dart';
import 'package:infolab_app/util/Configuracoes.dart';
import 'package:infolab_app/views/widgets/BotaoCustomizado.dart';
import 'package:infolab_app/views/widgets/CustomInput.dart';
import 'package:validadores/Validador.dart';

class NovoCampus extends StatefulWidget {
  Campus campus;
  NovoCampus(this.campus);

  @override
  _NovoCampusState createState() => _NovoCampusState();
}

class _NovoCampusState extends State<NovoCampus> {
  List<DropdownMenuItem<String>> _listaItensDropEstados = List();
  final _formKey = GlobalKey<FormState>();
  Campus _campus;
  BuildContext _dialogContext;

  String _itemSelecionadoEstado;

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
                Text("Salvando Campus...")
              ],
            ),
          );
        });
  }

  _salvarCampus() async {
    _abrirDialog(_dialogContext);
    Firestore db = Firestore.instance;

    db
        .collection("campus")
        .document(_campus.id)
        .setData(_campus.toMap())
        .then((_) {
      Navigator.pop(_dialogContext);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _campus = widget.campus != null ? widget.campus : Campus.gerarId();
    if (widget.campus != null) {
      _nomeController = new TextEditingController(text: _campus.nome);
      _cidadeController = new TextEditingController(text: _campus.cidade);
      _itemSelecionadoEstado = _campus.estado;
    }
  }

  _carregarItensDropdown() {
    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cidadeController = TextEditingController();

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

  _salvarCidade(Cidade cidade) async {
    Firestore db = Firestore.instance;
    if (_itemSelecionadoEstado != null &&
        cidade != null &&
        (cidade.nome.isNotEmpty)) {
      db.collection("cidades").document(cidade.id).setData(cidade.toMap());
    }
  }

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.campus != null ? "Editar Campus" : "Novo Campus"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: CustomInput(
                    controller: _nomeController,
                    hint: "Nome*",
                    onSaved: (nome) {
                      _campus.nome = nome;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
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
                            _campus.estado = estado;
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
                              _campus.estado = valor;
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
                          "Adicionar " + this._cidadeController.text,
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.transparent),
                        ),
                        onPressed: () {
                          if (_itemSelecionadoEstado != null) {
                            Cidade cidade = Cidade.gerarId();
                            cidade.estado = _itemSelecionadoEstado;
                            cidade.nome = this._campus.cidade;
                            _salvarCidade(cidade);
                            FocusScope.of(context).requestFocus(focus);
                          }
                        },
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(fontSize: 20),
                      onTap: () {
                        this._cidadeController.text = "";
                      },
                      controller: this._cidadeController,
                      onChanged: (_) {
                        _campus.cidade = this._cidadeController.text;
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
                      _campus.cidade = suggestion['nome'];
                      if (_itemSelecionadoEstado != null) {
                        this._cidadeController.text = suggestion['nome'];
                      }
                    },
                  ),
                ),
                BotaoCustomizado(
                  texto: "Salvar Campus",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //salva campos
                      _formKey.currentState.save();

                      //Configura dialog context
                      _dialogContext = context;

                      //salvar lab
                      _salvarCampus();
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
