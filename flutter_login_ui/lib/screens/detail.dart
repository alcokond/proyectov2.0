import 'package:flutter_login_ui/api/apiDenuncias.dart';
import 'package:flutter_login_ui/modelo/denuncias.dart';
import 'package:flutter_login_ui/notifier/denuncia_notifier.dart';
import 'package:flutter_login_ui/screens/denuncia_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'denuncia_form.dart';

class denunciaDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DenunciaNotifier denunciaNotifier = Provider.of<DenunciaNotifier>(context);

    _ondenunciaDeleted(Denuncia denuncia) {
      Navigator.pop(context);
      denunciaNotifier.deleteDenuncia(denuncia);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(denunciaNotifier.currentDenuncia.nombre),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  denunciaNotifier.currentDenuncia.imagen != null
                      ? denunciaNotifier.currentDenuncia.imagen
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 24),
                Text(
                  denunciaNotifier.currentDenuncia.nombre,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  'Tipo: ${denunciaNotifier.currentDenuncia.tipo}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
                Text(
                  "descripcion : ${denunciaNotifier.currentDenuncia.descripcion} ",
                  style: TextStyle(fontSize: 18, decoration: TextDecoration.underline),
                ),
                SizedBox(height: 16),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return DenunciaForm(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => deleteDenuncia(denunciaNotifier.currentDenuncia, _ondenunciaDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}