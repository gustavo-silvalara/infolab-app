import 'package:flutter/material.dart';
import 'package:infolab_app/models/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infolab_app/views/widgets/CustomInput.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController(
    text: 'gustavo.silvalara@outlook.com',
  );
  TextEditingController _controllerSenha = TextEditingController(
    text: '12345678',
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

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains('@')) {
      if (senha.isNotEmpty && senha.length > 6) {
        Usuario usuario = _configurarUsuario(email, senha);
        if (_cadastrar) {
          _cadastrarUsuario(usuario);
        } else {
          _logarUsuario(usuario);
        }
      } else {
        setState(() {
          _mensagemErro = 'A senha precisa ter 8 ou mais caracteres!';
        });
      }
    } else {
      setState(() {
        _mensagemErro = 'Preencha o e-mail corretamente';
      });
    }
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
                  child: Image.asset(
                    "imagens/if.png",
                    width: 124,
                    height: 124,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Logar'),
                    Switch(
                      value: _cadastrar,
                      onChanged: (bool valor) {
                        setState(() {
                          _cadastrar = valor;
                          _textoBotao = (_cadastrar) ? 'Cadastrar' : 'Entrar';
                        });
                      },
                    ),
                    Text('Cadastrar'),
                  ],
                ),
                RaisedButton(
                  child: Text(
                    _textoBotao,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xff359830),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  onPressed: () {
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
