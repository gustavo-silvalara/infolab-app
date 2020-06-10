import 'package:flutter/material.dart';

class ItemLaboratorio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 120,
                height: 120,
                child: Container(
                  color: Colors.green,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'LAB-03',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Pedro Neto'),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  onPressed: () {},
                  child: Icon(Icons.edit, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
