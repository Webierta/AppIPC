import 'package:flutter/material.dart';
import 'package:renta_ipc/widgets/buildBoxDecoration.dart';
import 'package:renta_ipc/widgets/customAppBar.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  static const String id = 'about';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: CustomAppBar(titulo: 'About'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'IPC APP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 42.0,
                    color: Colors.indigo[800],
                  ),
                ),
                Divider(
                  color: Colors.indigo[300],
                ),
                Text(
                  'El IPC a un clic',
                  style: TextStyle(
                    color: Colors.indigo,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                  decoration: const Box().buildShadow(),
                  child: Image.asset('assets/images/ipcclic.jpg'),
                ),
                _textoABout(context),
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    decoration: const Box().buildShadow(),
                    child: Image.asset('assets/images/paypal.jpg'),
                  ),
                  onTap: () async {
                    const url =
                        'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=986PSAHLH6N4L';
                    if (await canLaunch(url)) {
                      await launch(url, forceSafariVC: false);
                    } else {
                      throw 'No se ha podido abrir la web';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<String> _textoABout(BuildContext context) {
    return FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString('assets/files/about.txt'),
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? 'Error: archivo no encontrado',
          softWrap: true,
          style: TextStyle(fontSize: 22, color: Colors.black87),
        );
      },
    );
  }
}
