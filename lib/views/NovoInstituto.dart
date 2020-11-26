import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Instituto.dart';
import 'package:infolab_app/util/Configuracoes.dart';
import 'package:infolab_app/views/widgets/BotaoCustomizado.dart';
import 'package:infolab_app/views/widgets/CustomInput.dart';
import 'package:validadores/Validador.dart';

class NovoInstituto extends StatefulWidget {
  Instituto instituto;
  NovoInstituto(this.instituto);

  @override
  _NovoInstitutoState createState() => _NovoInstitutoState();
}

class _NovoInstitutoState extends State<NovoInstituto> {
  List<DropdownMenuItem<String>> _listaItensDropEstados = List();
  final _formKey = GlobalKey<FormState>();
  Instituto _instituto;
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
                Text("Salvando Instituto...")
              ],
            ),
          );
        });
  }

  _salvarInstituto() async {
    _abrirDialog(_dialogContext);
    Firestore db = Firestore.instance;

    db
        .collection("institutos")
        .document(_instituto.id)
        .setData(_instituto.toMap())
        .then((_) {
      Navigator.pop(_dialogContext);
      Navigator.pop(context);
    });
  }

  _showDialogConfirma() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Remover Instituição?"),
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
                await deletar();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deletar() async {
    Firestore db = Firestore.instance;
    db.collection("institutos").document(_instituto.id).delete();
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _instituto =
        widget.instituto != null ? widget.instituto : Instituto.gerarId();
    if (widget.instituto != null) {
      _nomeController = new TextEditingController(text: _instituto.nome);
      _itemSelecionadoEstado = _instituto.estado;
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
        title: Text(widget.instituto != null
            ? "Editar Instituição"
            : "Nova Instituição"),
        actions: [
          if (widget.instituto?.id != null)
            FlatButton(
                onPressed: _showDialogConfirma, child: Icon(Icons.delete))
        ],
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
                      _instituto.nome = nome;
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
                            _instituto.estado = estado;
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
                              _instituto.estado = valor;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                BotaoCustomizado(
                  texto: "Salvar Instituto",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //salva campos
                      _formKey.currentState.save();

                      //Configura dialog context
                      _dialogContext = context;

                      //salvar lab
                      _salvarInstituto();
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
