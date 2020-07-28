import 'package:flutter/material.dart';
import 'package:infolab_app/models/Area.dart';

class ItemArea extends StatelessWidget {
  Area area;
  VoidCallback onTapItem;
  VoidCallback onPressedEdit;

  ItemArea({
    @required this.area,
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
                        area.nome,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        area.grandeArea,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
