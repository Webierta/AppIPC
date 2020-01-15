import 'package:flutter/material.dart';
import 'package:renta_ipc/pages/about.dart';
import 'package:renta_ipc/pages/home.dart';
import 'package:renta_ipc/pages/ipc.dart';
import 'package:renta_ipc/pages/renta.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home.id:
        return MaterialPageRoute(builder: (_) => Home());
      case Ipc.id:
        return MaterialPageRoute(builder: (_) => Ipc());
      case Renta.id:
        return MaterialPageRoute(builder: (_) => Renta());
      case About.id:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => About(),
        );
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(nameError) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Invalid route: $nameError'),
        ),
      );
    });
  }
}
