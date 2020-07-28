import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Cidade.dart';
import 'package:infolab_app/util/Configuracoes.dart';
import 'package:infolab_app/views/widgets/BotaoCustomizado.dart';
import 'package:infolab_app/views/widgets/CustomInput.dart';
import 'package:validadores/Validador.dart';

class NovaCidade extends StatefulWidget {
  Cidade cidade;
  NovaCidade(this.cidade);

  @override
  _NovaCidadeState createState() => _NovaCidadeState();
}

class _NovaCidadeState extends State<NovaCidade> {
  List<DropdownMenuItem<String>> _listaItensDropEstados = List();
  final _formKey = GlobalKey<FormState>();
  Cidade _cidade;
  BuildContext _dialogContext;

  String _itemSelecionadoEstado;

  Map<String, String> grandesAreas = new Map();

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
                Text("Salvando Cidade...")
              ],
            ),
          );
        });
  }

  _salvarCidade() async {
    _abrirDialog(_dialogContext);
    Firestore db = Firestore.instance;

    db
        .collection("cidades")
        .document(_cidade.id)
        .setData(_cidade.toMap())
        .then((_) {
      Navigator.pop(_dialogContext);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _cidade = widget.cidade != null ? widget.cidade : Cidade.gerarId();
    if (widget.cidade != null) {
      _nomeController = new TextEditingController(text: _cidade.nome);
      _itemSelecionadoEstado = _cidade.estado;
    }
  }

  _carregarItensDropdown() {
    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  TextEditingController _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cidade != null ? "Editar Cidade" : "Nova Cidade"),
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
                      _cidade.nome = nome;
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
                            _cidade.estado = estado;
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
                              _cidade.estado = valor;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                BotaoCustomizado(
                  texto: "Salvar Cidade",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //salva campos
                      _formKey.currentState.save();

                      //Configura dialog context
                      _dialogContext = context;

                      //salvar lab
                      _salvarCidade();
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
