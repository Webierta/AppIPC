import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:renta_ipc/route_generator.dart';
import 'pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [const Locale('es', 'ES')],    
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        //accentColor: Colors.white,
        //canvasColor: Colors.indigo, //indigo.shade100,
        //scaffoldBackgroundColor: Colors.transparent,
        buttonTheme: ButtonThemeData(
          minWidth: 200.0,
          buttonColor: Colors.indigoAccent[700],
        ),
      ),
      home: Home(),
      initialRoute: Home.id, //'/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
