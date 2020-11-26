import 'package:flutter/material.dart';
import 'package:infolab_app/models/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infolab_app/util/Configuracoes.dart';
import 'package:infolab_app/views/widgets/CustomInput.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController(
    text: '',
  );
  TextEditingController _controllerSenha = TextEditingController(
    text: '',
  );

  bool _cadastrar = false;

  String _mensagemErro = '';
  String _textoBotao = 'Entrar';

  Usuario _configurarUsuario(String email, String senha) {
    Usuario usuario = Usuario();
    usuario.email = email;
    usuario.senha = senha;
    return usuario;
  }

  _logarUsuario(Usuario usuario) async {
    _abrirDialog(_dialogContext);
    FirebaseAuth auth = await FirebaseAuth.instance;
    usuario.email = usuario.email.trim();
    usuario.senha = usuario.senha.trim();
    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) async {
      LocalStorage storage = new LocalStorage('infolab');
      storage.setItem("email", usuario.email);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("email", usuario.email);

      Navigator.pop(_dialogContext);
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains('@')) {
      if (senha.isNotEmpty) {
        Usuario usuario = _configurarUsuario(email, senha);
        _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = 'A senha não está preenchida!';
        });
      }
    } else {
      setState(() {
        _mensagemErro = 'Preencha o e-mail corretamente';
      });
    }
  }

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
                Text("Entrando...")
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Center(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Image.asset(
                    "imagens/if.png",
                    width: 124,
                    height: 124,
                  ),
                       Image.asset(
                    "imagens/fortec.png",
                    width: 124,
                    height: 124,
                  ),
                    ]
                  ),
                ),
                  ),
                CustomInput(
                  controller: _controllerEmail,
                  hint: 'E-mail',
                  autofocus: true,
                  type: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 5.0,
                ),
                CustomInput(
                  controller: _controllerSenha,
                  hint: 'Senha',
                  obscure: true,
                ),
                SizedBox(
                  height: 30.0,
                ),
                RaisedButton(
                  child: Text(
                    _textoBotao,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xff359830),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  onPressed: () {
                    _dialogContext = context;
                    _validarCampos();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffC90C0F),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
