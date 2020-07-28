import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Area.dart';
import 'package:infolab_app/util/Configuracoes.dart';
import 'package:infolab_app/views/widgets/BotaoCustomizado.dart';
import 'package:infolab_app/views/widgets/CustomInput.dart';
import 'package:validadores/Validador.dart';

class NovaArea extends StatefulWidget {
  Area area;
  NovaArea(this.area);

  @override
  _NovaAreaState createState() => _NovaAreaState();
}

class _NovaAreaState extends State<NovaArea> {
  List<DropdownMenuItem<String>> _listaItensDropAreas = List();
  final _formKey = GlobalKey<FormState>();
  Area _area;
  BuildContext _dialogContext;

  String _itemSelecionadoCategoria;

  Map<String, String> grandesAreas = new Map();
  Map<String, String> grandesAreasI = new Map();

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
                Text("Salvando Area...")
              ],
            ),
          );
        });
  }

  _salvarArea() async {
    _abrirDialog(_dialogContext);
    Firestore db = Firestore.instance;

    db.collection("areas").document(_area.id).setData(_area.toMap()).then((_) {
      Navigator.pop(_dialogContext);
      Navigator.pop(context);
    });
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

    this.grandesAreasI = {
      "Ciências Exatas e da Terra": 'exatas',
      "Ciências Biológicas": 'biologicas',
      "Engenharias": 'engenharias',
      "Ciências da Saúde": "saude",
      "Ciências Agrárias": "agrarias",
      "Ciências Sociais": "sociais",
      "Ciências Humanas": "humanas",
      "Linguística, Letras e Artes": "letras",
      "Outros": "outros"
    };

    _area = widget.area != null ? widget.area : Area.gerarId();
    if (widget.area != null) {
      _nomeController = new TextEditingController(text: _area.nome);
      _itemSelecionadoCategoria = this.grandesAreasI[_area.grandeArea];
    }
  }

  _carregarItensDropdown() {
    //Estados
    _listaItensDropAreas = Configuracoes.getEstados();
  }

  TextEditingController _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.area != null ? "Editar Área" : "Nova Área"),
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
                      _area.nome = nome;
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
                          value: _itemSelecionadoCategoria,
                          hint: Text("Grande Área"),
                          onSaved: (grandeA) {
                            print(grandeA);
                            _area.grandeArea = this.grandesAreasI[grandeA];
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaItensDropAreas,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoCategoria = valor;
                              _area.grandeArea = this.grandesAreas[valor];
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                BotaoCustomizado(
                  texto: "Salvar Area",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //salva campos
                      _formKey.currentState.save();

                      //Configura dialog context
                      _dialogContext = context;

                      //salvar lab
                      _salvarArea();
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
