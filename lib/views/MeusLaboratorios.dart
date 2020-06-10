import 'package:flutter/material.dart';
import 'package:infolab_app/views/widgets/ItemLaboratorio.dart';

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
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (_, indice) {
          return ItemLaboratorio();
        },
      ),
    );
  }
}
