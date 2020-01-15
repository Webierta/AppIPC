import 'package:flutter/material.dart';
import 'package:renta_ipc/pages/about.dart';
import 'package:renta_ipc/pages/ipc.dart';
import 'package:renta_ipc/pages/renta.dart';
import 'package:renta_ipc/widgets/buildBoxDecoration.dart';
import 'package:renta_ipc/widgets/customAppBar.dart';

class Home extends StatefulWidget {
  static const String id = 'home';
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: CustomAppBar(
        titulo: 'El IPC en un clic',
        accionBoton: IconButton(
          icon: Icon(
            Icons.info,
            color: Colors.indigoAccent[700],
          ),
          onPressed: () => Navigator.of(context).pushNamed(About.id),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const Box().buildGradient(context),
              padding: const EdgeInsets.all(20.0),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: _orientation == Orientation.portrait
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const BoxUtil(id: Ipc.id),
                          const BoxUtil(id: Renta.id),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const BoxUtil(id: Ipc.id),
                          const BoxUtil(id: Renta.id),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxUtil extends StatelessWidget {
  final String id;
  const BoxUtil({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rutaImagen = 'assets/images/$id.png';
    var textoBoton = id == 'ipc' ? 'IPC en un clic' : 'Actualizar Renta';
    return Container(
      margin: const EdgeInsets.all(20.0),
      decoration: const Box().buildShadow(),
      child: Column(
        children: <Widget>[
          Image.asset(rutaImagen),
          RaisedButton(
            child: Text(textoBoton, style: TextStyle(fontSize: 20)),
            textColor: Colors.white,
            onPressed: () => Navigator.of(context).pushNamed(id),
          ),
        ],
      ),
    );
  }
}
