import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final Widget accionBoton;

  CustomAppBar({Key key, this.titulo, this.accionBoton}) : super(key: key);
  /* const CustomAppBar({Key key, this.titulo, this.accionBoton})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key); */

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titulo),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigo[900],
              Colors.indigo[100],
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      actions: <Widget>[
        accionBoton ?? SizedBox.shrink(),
      ],
    );
  }
}
