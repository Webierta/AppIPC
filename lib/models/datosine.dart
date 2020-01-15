import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DatosIne {
  double ipc;
  String fechaEs;
  double variacion;

  String date1;
  String date2;
  double ipc1;
  double ipc2;
  double variacionIpc;

  final baseUrl = 'servicios.ine.es/wstempus/js/ES/DATOS_SERIE/';

  DatosIne({this.ipc, this.fechaEs, this.variacion}) {
    Intl.defaultLocale = 'es_ES';
  }

  String capitalize(cadena) {
    if (cadena != null) return cadena[0].toUpperCase() + cadena.substring(1);
    return '';
  }

  getIpc({@required String serie, @required String dateIpc}) async {
    //var url = 'https://$baseUrl$serie?nult=1';
    var url = 'https://$baseUrl$serie?date=$dateIpc';
    var http = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    try {
      var request = await http
        .getUrl(Uri.parse(url))
        .timeout(const Duration(seconds: 7));
      //request.headers.set('content-type', 'application/json');
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      var objetoJson = json.decode(responseBody);
      if ((objetoJson['Data'][0]['Valor']) != null) {
        var datos = objetoJson['Data'][0];
        var valor = datos['Valor'] is double ? datos['Valor'] : null;
        if (ipc == null || fechaEs == null) {
          ipc = valor;
          var fechaIpc = datos['Fecha'];
          if (fechaIpc is int) {
            var fecha = DateTime.fromMillisecondsSinceEpoch(fechaIpc).toLocal();
            fechaEs = await initializeDateFormatting()
                .then((_) => capitalize(DateFormat('MMMM yyyy').format(fecha)));
          }
        } else {
          variacion = valor;
        }
      }
    } catch (e) {
      ipc = null;
      fechaEs = null;
      variacion = null;
    }
  }

  Future<double> getDataIne(
      {@required String serie, String date1, String date2}) async {
    var url = date2 != null
        ? 'http://$baseUrl$serie?date=$date1:$date2'
        : 'http://$baseUrl$serie?date=$date1';
    print(url);
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      //print(responseBody);
      var datoIne = date2 != null
          ? json.decode(responseBody)['Data'][12]['Valor'] // variacion
          : json.decode(responseBody)['Data'][0]['Valor']; // valor ipc
      return datoIne;
    } catch (e) {
      return null;
    }
  }
}
