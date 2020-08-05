import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infolab_app/models/Usuario.dart';
import 'package:infolab_app/util/Configuracoes.dart';
import 'package:infolab_app/views/widgets/BotaoCustomizado.dart';
import 'package:infolab_app/views/widgets/CustomInput.dart';
import 'package:validadores/Validador.dart';

class NovoUsuario extends StatefulWidget {
  @override
  _NovoUsuarioState createState() => _NovoUsuarioState();
}

class _NovoUsuarioState extends State<NovoUsuario> {
  final _formKey = GlobalKey<FormState>();
  BuildContext _dialogContext;
  Usuario _usuario = new Usuario();
  List<DropdownMenuItem<String>> _listaPerfis = List();
  String _itemSelecionadoPerfil;

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
                Text("Salvando Usuário...")
              ],
            ),
          );
        });
  }

  void _showDialogConfirma() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Endereço de Email Inválido!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _salvarUsuario() async {
    _abrirDialog(_dialogContext);
    Firestore db = Firestore.instance;
    FirebaseAuth auth = await FirebaseAuth.instance;
    _emailController.text = _emailController.text.trim();
    _senhaController.text = _senhaController.text.trim();
    auth
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _senhaController.text)
        .catchError((e) {
      _emailController.text = "";
      _senhaController.text = "";
      Navigator.pop(_dialogContext);
      _showDialogConfirma();
      return;
    }).then((novoUsuario) {
      setState(() {
        _usuario.idUsuario = novoUsuario.user.uid;
        _usuario.email = novoUsuario.user.email;
        _usuario.perfil = _itemSelecionadoPerfil;
      });
      print(_usuario.toMap());
      db
          .collection("usuarios")
          .document(_usuario.idUsuario)
          .setData(_usuario.toMap())
          .then((_) {
        Navigator.pop(_dialogContext);
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _listaPerfis = Configuracoes.getPerfis();
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Usuário"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomInput(
                  controller: _emailController,
                  hint: 'E-mail',
                  autofocus: true,
                  type: TextInputType.emailAddress,
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        .valido(valor);
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                CustomInput(
                  controller: _senhaController,
                  hint: 'Senha',
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                        .valido(valor);
                  },
                  obscure: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: _itemSelecionadoPerfil,
                    hint: Text("Perfis"),
                    onSaved: (perfil) {
                      _itemSelecionadoPerfil = perfil;
                    },
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    items: _listaPerfis,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                    onChanged: (valor) {
                      setState(() {
                        _itemSelecionadoPerfil = valor;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                BotaoCustomizado(
                  texto: "Salvar Usuário",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //salva campos
                      _formKey.currentState.save();

                      //Configura dialog context
                      _dialogContext = context;

                      //salvar lab
                      _salvarUsuario();
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
