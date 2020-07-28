import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  _salvarUsuario() async {
    _abrirDialog(_dialogContext);
    FirebaseAuth auth = await FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _senhaController.text)
        .then((_) {
      Navigator.pop(_dialogContext);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
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
