import 'package:flutter/material.dart';

class MeusLaboratorios extends StatefulWidget {
  @override
  _MeusLaboratoriosState createState() => _MeusLaboratoriosState();
}

class _MeusLaboratoriosState extends State<MeusLaboratorios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Laboratórios'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/novo-laboratorio');
        },
      ),
      body: Container(),
    );
  }
}
