import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:renta_ipc/widgets/buildBoxDecoration.dart';
import 'package:renta_ipc/widgets/customAppBar.dart';
import '../models/datosine.dart';
import '../models/datosTag.dart';

enum Status { none, ok, error, noPublicado, tiempoExcedido }

class Renta extends StatefulWidget {
  static const String id = 'renta';
  Renta({Key key}) : super(key: key);

  @override
  _RentaState createState() => _RentaState();
}

class _RentaState extends State<Renta> {
  final _formKey = GlobalKey<FormState>();
  final _rentaController = TextEditingController();
  final _dateController = TextEditingController();

  double _renta;
  DateTime _date1;
  DateTime _date2;

  DatosIne datosIne = DatosIne();
  List<DatosTag> listaDatos = List();
  var _ipc1;
  var _ipc2;
  var _varIpc;
  var _rentaUp;

  Status _status;
  bool _progressActive;

  @override
  void initState() {
    super.initState();
    _ipc1 = DatosTag(tag: 'Valor IPC inicial', valor: '');
    _ipc2 = DatosTag(tag: 'Valor IPC final', valor: '');
    _varIpc = DatosTag(tag: 'Tasa de variación', valor: '');
    _rentaUp = DatosTag(tag: 'Renta actualizada', valor: '');
    listaDatos..add(_ipc1)..add(_ipc2)..add(_varIpc)..add(_rentaUp);
  }

  void actualizarRenta() {
    setState(() {
      _ipc1.tag = 'IPC ${DateFormat('MMM yyyy').format(_date1)}';
      _ipc1.valor = '${datosIne.ipc1}';
      _ipc2.tag = 'IPC ${DateFormat('MMM yyyy').format(_date2)}';
      _ipc2.valor = '${datosIne.ipc2}';
      _varIpc.valor = '${datosIne.variacionIpc} %';
      _rentaUp.valor = calcularRenta() + ' €';
      _progressActive = false;
    });
  }

  void reset() {
    setState(() {
      datosIne.ipc1 = null;
      datosIne.ipc2 = null;
      datosIne.variacionIpc = null;
      _status = Status.none;
      listaDatos.forEach((item) => item.valor = '');
      _ipc1.tag = 'Valor IPC inicial';
      _ipc2.tag = 'Valor IPC final';
    });
  }

  String calcularRenta() {
    String _coeficienteIndices =
        (datosIne.ipc2 / datosIne.ipc1).toStringAsFixed(3);
    double _rentaNueva = _renta * (double.parse(_coeficienteIndices));
    return _rentaNueva.toStringAsFixed(2);
  }

  String calcularDiferencia() {
    var _nuevaRenta = double.parse(calcularRenta());
    var _diferencia = _nuevaRenta - _renta;
    var _signo = '';
    if (_diferencia.sign == 1.0) _signo = '+';
    return _signo + _diferencia.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: CustomAppBar(
        titulo: 'Actualizar Renta',
        // TODO: accionBoton: GUARDAR captura, pdf ??
        // TODO: accionBoton: ENVIAR ??
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(decoration: const Box().buildGradient(context)),
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 30, right: 45, left: 45, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    autovalidate: true,
                    child: buildChildForm(context),
                  ),
                  //calcularBoton(context),
                  Container(
                    decoration: const Box().buildShadow(),
                    margin: const EdgeInsets.only(top: 30.0),
                    child: buildListView(context),
                  ),
                  Container(
                    child: Text(
                      _status == Status.ok
                          ? 'Elaboración propia con datos extraídos del sitio web del INE: www.ine.es'
                          : '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChildForm(BuildContext context) {
    var _apaisado = MediaQuery.of(context).orientation == Orientation.landscape;
    Widget childForm;
    if (_apaisado) {
      childForm = Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(children: <Widget>[rentaFormField(context)]),
          ),
          Expanded(
            flex: 2,
            child: Column(children: <Widget>[dateFormField(context)]),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: calcularBoton(context),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      childForm = Column(
        children: <Widget>[
          rentaFormField(context),
          dateFormField(context),
          SizedBox(height: 10.0),
          calcularBoton(context),
        ],
      );
    }
    return childForm;
  }

  TextFormField rentaFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '450.00',
        //helperText: 'Separa los céntimos con un punto',
        labelText: 'Renta',
        hintStyle: TextStyle(color: Colors.white38),
        //helperStyle: TextStyle(color: Colors.white70),
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(color: Colors.red[400]),
        prefixIcon: Icon(
          Icons.euro_symbol, //size: 28.0,
          color: Colors.white,
        ),
      ),
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      validator: (value) {
        if (value.trim().isEmpty) return 'Renta requerida';
        if (double.tryParse(value) != null) return null;
        return 'Dato no reconocido';
      },
      controller: _rentaController,
      onSaved: (value) {
        return setState(() => _renta = double.parse(value));
      },
      onChanged: (value) => reset(),
    );
  }

  TextFormField dateFormField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Fecha',
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(color: Colors.red[400]),
        prefixIcon: Icon(
          Icons.calendar_today,
          color: Colors.white,
        ),
      ),
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      validator: (value) => value.trim().isEmpty ? 'Fecha requerida' : null,
      controller: _dateController,
      onTap: () async {
        DateTime hoy = DateTime.now().toLocal();
        DateTime lastDate = DateTime(hoy.year - 1, hoy.month, 0);
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime picked = await showDatePicker(
          context: context,
          locale: const Locale('es', 'ES'),
          initialDate: lastDate,
          firstDate: DateTime(2002, 1),
          lastDate: lastDate,
        );
        if (picked != null) {
          if (picked != _date1) reset();
          _dateController.text =
              datosIne.capitalize(DateFormat('MMMM yyyy').format(picked));
          setState(() {
            _date1 = DateTime(picked.year, picked.month);
            _date2 = DateTime(picked.year + 1, picked.month);
          });
        }
      },
    );
  }

  Widget calcularBoton(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return RaisedButton(
        child: _progressActive == true
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                'Calcular',
                style: TextStyle(fontSize: 20),
              ),
        textColor: Colors.white,
        elevation: 10,
        highlightElevation: 2,
        highlightColor: Colors.indigo[100],
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _progressActive = true;
            final snackBar = SnackBar(content: Text('Procesando datos'));
            Scaffold.of(context).showSnackBar(snackBar);
            await _enviarPeticion()
                .then((_) => Scaffold.of(context).hideCurrentSnackBar());

            var _msgError;
            if (_status == Status.noPublicado) {
              _msgError = 'Datos no disponibles para la fecha final';
            } else if (_status == Status.tiempoExcedido) {
              _msgError =
                  'La petición ha excedido el tiempo. Comprueba tu conexión o vuelve a intentarlo';
            } else if (_status != Status.ok) {
              _msgError =
                  'Error obteniendo los datos. Comprueba tu conexión o vuelve a intentarlo';
            }
            if (_msgError != null) {
              final snackBarError = SnackBar(
                content: Text(_msgError),
                backgroundColor: Colors.red[900],
              );
              Scaffold.of(context).showSnackBar(snackBarError);
              setState(() => _progressActive = false);
            }
          }
        },
      );
    });
  }

  _enviarPeticion() async {
    _formKey.currentState.save();
    datosIne.date1 = DateFormat('yyyyMM01').format(_date1);
    datosIne.date2 = DateFormat('yyyyMM01').format(_date2);
    var tiempoExcedido = false;
    datosIne.ipc1 = await datosIne
        .getDataIne(serie: 'IPC206446', date1: datosIne.date1)
        .timeout(const Duration(seconds: 7), onTimeout: () {
      tiempoExcedido = true;
      return null;
    });
    datosIne.ipc2 = await datosIne
        .getDataIne(serie: 'IPC206446', date1: datosIne.date2)
        .timeout(const Duration(seconds: 7), onTimeout: () {
      tiempoExcedido = true;
      return null;
    });
    datosIne.variacionIpc = await datosIne
        .getDataIne(
            serie: 'IPC206448', date1: datosIne.date1, date2: datosIne.date2)
        .timeout(const Duration(seconds: 7), onTimeout: () {
      tiempoExcedido = true;
      return null;
    });
    print('date1: ${datosIne.date1}, date2: ${datosIne.date2}');
    print('${datosIne.ipc1} ${datosIne.ipc2} ${datosIne.variacionIpc}');
    if (tiempoExcedido) {
      _status = Status.tiempoExcedido;
    } else if (datosIne.ipc2 == null) {
      _status = Status.noPublicado;
    } else if (datosIne.date1 == null ||
        datosIne.date2 == null ||
        datosIne.ipc1 == null ||
        datosIne.variacionIpc == null) {
      _status = Status.error;
    } else {
      _status = Status.ok;
      actualizarRenta();
    }
  }

  Widget buildListView(BuildContext context) {
    var _apaisado = MediaQuery.of(context).orientation == Orientation.landscape;
    Widget listView;
    if (_apaisado) {
      listView = ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Column(children: <Widget>[_buildItem(_ipc1)])),
              Expanded(child: Column(children: <Widget>[_buildItem(_varIpc)])),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: Column(children: <Widget>[_buildItem(_ipc2)])),
              Expanded(child: Column(children: <Widget>[_buildItem(_rentaUp)])),
            ],
          ),
        ],
      );
    } else {
      listView = ListView(
        shrinkWrap: true,
        children: listaDatos.map(_buildItem).toList(),
      );
    }
    return listView;
  }

  Widget _buildItem(DatosTag dato) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Widget dif = (dato.tag == 'Renta actualizada' && _status == Status.ok)
        ? Text(calcularDiferencia() + ' €')
        : null;
    return ListTile(
      title: Text(
        dato.valor,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: dato.tag == 'Renta actualizada'
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      subtitle: Text(dato.tag),
      leading: _orientation == Orientation.landscape ? dif : null,
      trailing: _orientation == Orientation.portrait ? dif : null,
    );
  }
}
