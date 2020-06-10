import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Laboratorios extends StatefulWidget {
  @override
  _LaboratoriosState createState() => _LaboratoriosState();
}

class _LaboratoriosState extends State<Laboratorios> {
  List<String> itensMenu = [];

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case 'Meus Laboratórios':
        Navigator.pushNamed(context, '/meus-laboratorios');
        break;
      case 'Entrar/Cadastrar':
        Navigator.pushReplacementNamed(context, '/login');
        break;
      case 'Sair':
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.popAndPushNamed(context, '/login');
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    itensMenu = usuarioLogado == null
        ? ['Entrar/Cadastrar']
        : ['Meus Laboratórios', 'Sair'];
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laboratórios'),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: Text('Laboratórios'),
      ),
    );
  }
}
