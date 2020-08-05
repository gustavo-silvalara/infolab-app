import 'package:flutter/material.dart';
import 'package:infolab_app/models/Usuario.dart';

class ItemUsuario extends StatelessWidget {
  Usuario usuario;
  VoidCallback onTapItem;
  VoidCallback onPressedEdit;

  ItemUsuario({
    @required this.usuario,
    this.onTapItem,
    this.onPressedEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        usuario.email,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              if (this.onPressedEdit != null)
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    onPressed: this.onPressedEdit,
                    child: Icon(Icons.delete, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
