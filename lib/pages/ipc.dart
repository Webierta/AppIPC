import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:renta_ipc/widgets/buildBoxDecoration.dart';
import 'package:renta_ipc/widgets/customAppBar.dart';
import '../models/datosine.dart';
import '../models/datosTag.dart';

class Ipc extends StatefulWidget {
  static const String id = 'ipc';

  Ipc({Key key}) : super(key: key);

  @override
  _IpcState createState() => _IpcState();
}

class _IpcState extends State<Ipc> {
  DatosIne datosIne = DatosIne();
  List<DatosTag> listaDatos = List();
  var _fechaIpc;
  var _valorIpc;
  var _variaIpc;
  bool _progressActive;

  @override
  void initState() {
    super.initState();
    _fechaIpc = DatosTag(tag: 'Fecha', valor: '');
    _valorIpc = DatosTag(tag: 'Valor IPC', valor: '');
    _variaIpc = DatosTag(tag: 'Variación anual', valor: '');
    listaDatos..add(_fechaIpc)..add(_valorIpc)..add(_variaIpc);
  }

  void actualizar() {
    setState(() {
      _fechaIpc.valor = datosIne.fechaEs;
      _valorIpc.valor = '${datosIne.ipc}';
      _variaIpc.valor = '${datosIne.variacion} %';
    });
  }

  void reset() {
    setState(() {
      datosIne.fechaEs = null;
      datosIne.ipc = null;
      datosIne.variacion = null;
      listaDatos.forEach((item) => item.valor = '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: 'Valor IPC'),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(decoration: const Box().buildGradient(context)),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        top: 45.0, left: 45.0, right: 45.0, bottom: 0.5),
                    decoration: const Box().buildShadow(),
                    child: ListView(
                      shrinkWrap: true,
                      children: listaDatos.map(_buildItem).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          listaDatos.every((data) => data.valor != '')
                              ? 'Fuente: Sitio web del INE: www.ine.es'
                              : '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  getBoton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(DatosTag dato) {
    return ListTile(
      title: Text(
        dato.valor,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      subtitle: Text(dato.tag),
    );
  }

  Widget getBoton(BuildContext context) {
    // TODO: Check red ??
    return Builder(builder: (BuildContext context) {
      return RaisedButton(
        child: _progressActive == true
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
            : Text(
                'Obtener IPC',
                style: TextStyle(fontSize: 20),
              ),
        textColor: Colors.white,
        onPressed: () async {
          if (listaDatos.every((data) => data.valor != '')) reset();
          setState(() => _progressActive = true);
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Procesando datos')));
          var dateActual = DateTime.now().toLocal();
          // dateActual = DateTime(2019, 12, 1); // TEST DATE
          var dateLastIpc = DateTime(dateActual.year, dateActual.month - 1);
          var fechaLastIpc = DateFormat('yyyyMM01').format(dateLastIpc);

          var peticiones = 3;
          //while (datosIne.ipc == null) {
          while (peticiones != 0) {
            print('$fechaLastIpc $peticiones');
            await datosIne
                .getIpc(serie: 'IPC206446', dateIpc: fechaLastIpc)
                .then((_) async {
              if (datosIne.ipc != null) {
                peticiones = 0;
                await datosIne
                    .getIpc(serie: 'IPC206448', dateIpc: fechaLastIpc)
                    .then((_) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  setState(() => _progressActive = false);
                });
              } else {
                dateLastIpc = DateTime(dateLastIpc.year, dateLastIpc.month - 1);
                fechaLastIpc = DateFormat('yyyyMM01').format(dateLastIpc);
                peticiones--;
              }
            });
          }
          print('IPC: ${datosIne.ipc}');

          if (datosIne.fechaEs is String &&
              datosIne.ipc is double &&
              datosIne.variacion is double) {
            //print('${datosIne.fechaEs}: ${datosIne.ipc} IPC ${datosIne._variaIpc}');
            actualizar();
            //print('$__fechaIpc: $__valorIpc IPC $__variaIpc');
          } else {
            setState(() => _progressActive = false);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Error obteniendo datos'),
              backgroundColor: Colors.red[900],
            ));
          }
        },
      );
    });
  }
}
