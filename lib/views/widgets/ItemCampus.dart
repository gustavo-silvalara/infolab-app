import 'package:flutter/material.dart';
import 'package:infolab_app/models/Campus.dart';

class ItemCampus extends StatelessWidget {
  Campus campus;
  VoidCallback onTapItem;
  VoidCallback onPressedEdit;

  ItemCampus({
    @required this.campus,
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
                        campus.nome,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        campus.estado,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        campus.cidade != null ? campus.cidade : "",
                        style: TextStyle(fontSize: 15),
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
                    child: Icon(Icons.edit, color: Colors.grey[400]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
