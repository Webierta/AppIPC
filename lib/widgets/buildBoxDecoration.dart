import 'package:flutter/material.dart';

class Box {
  const Box({Key key});

  BoxDecoration buildShadow() {
    return BoxDecoration(
      color: Colors.indigo[50],
      border: Border.all(color: Colors.black87),
      boxShadow: [
        BoxShadow(
          color: Colors.indigo[900],
          blurRadius: 10.0,
          offset: Offset(-10.0, 10.0),
        ),
      ],
    );
  }

  BoxDecoration buildGradient(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: _orientation == Orientation.portrait
            ? Alignment.bottomLeft
            : Alignment.bottomCenter,
        end: _orientation == Orientation.portrait
            ? Alignment.topRight
            : Alignment.topCenter,
        stops: [0.25, 0.75],
        colors: [
          Colors.indigo[800],
          Colors.indigo[100],
        ],
      ),
    );
  }
}
