import 'package:flutter/material.dart';
import 'package:infolab_app/main.dart';

class InputPesquisa extends StatelessWidget {
  final TextEditingController controller;
  VoidCallback onTyping;

  InputPesquisa({@required this.controller, this.onTyping});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: temaPadrao.primaryColor,
      child: TextField(
        controller: controller,
        onChanged: (val) {
          if (controller.text.length > 3) {
            Future.delayed(Duration(milliseconds: 450), () {
              this.onTyping;
            });
          }
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Pesquisar',
        ),
      ),
    );
  }
}
