import 'package:flutter/material.dart';
import 'package:infolab_app/views/CustomInput.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerEmail = TextEditingController(
    text: 'gustavo.silvalara@outlook.com',
  );
  TextEditingController _controllerSenha = TextEditingController(
    text: '123456',
  );

  bool _cadastrar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(''),
      //   elevation: 0.0,
      // ),
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
                        });
                      },
                    ),
                    Text('Cadastrar'),
                  ],
                ),
                RaisedButton(
                  child: Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xff359830),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  onPressed: () {
                    //arara
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
