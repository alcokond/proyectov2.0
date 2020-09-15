import 'dart:io';

import 'package:flutter_login_ui/api/apiDenuncias.dart';
import 'package:flutter_login_ui/modelo/denuncias.dart';
import 'package:flutter_login_ui/notifier/denuncia_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DenunciaForm extends StatefulWidget {
  final bool isUpdating;

  DenunciaForm({@required this.isUpdating});

  @override
  _DenunciaFormState createState() => _DenunciaFormState();
}

class _DenunciaFormState extends State<DenunciaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List _subingredients = [];
  Denuncia _currentDenuncia;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    DenunciaNotifier denunciaNotifier = Provider.of<DenunciaNotifier>(context, listen: false);

    if (denunciaNotifier.currentDenuncia != null) {
      _currentDenuncia = denunciaNotifier.currentDenuncia;
    } else {
      _currentDenuncia = new Denuncia();
    }


    _imageUrl = _currentDenuncia.imagen;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    } else if (_imageFile != null) {
      print('Mostrando imagen');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      initialValue: _currentDenuncia.nombre,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentDenuncia.nombre = value;
      },
    );
  }

  Widget _buildTipoField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      initialValue: _currentDenuncia.tipo,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Se necesita un tipo';
        }

        if (value.length < 3 || value.length > 20) {
          return 'El tipo debe medir mas de 3 y menos de 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentDenuncia.tipo = value;
      },
    );
  }



  _onDenunciaUploaded(Denuncia denuncia) {
    DenunciaNotifier denunciaNotifier = Provider.of<DenunciaNotifier>(context, listen: false);
    denunciaNotifier.addDenuncia(denuncia);
    Navigator.pop(context);
  }



  _saveDenuncia() {
    print('saveDenuncia Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

   // _currentDenuncia.descripcion = _subingredients;

    uploadDenunciaAndImage(_currentDenuncia, widget.isUpdating, _imageFile, _onDenunciaUploaded);

    print("nombre: ${_currentDenuncia.nombre}");
    print("tipo: ${_currentDenuncia.descripcion}");
    print("descripcion: ${_currentDenuncia.descripcion}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Denuncia Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Denuncia" : "Create Denuncia",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
              child: RaisedButton(
                onPressed: () => _getLocalImage(),
                child: Text(
                  'Add Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
                : SizedBox(height: 0),
            _buildNameField(),
            _buildTipoField(),
            SizedBox(height: 16),

          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveDenuncia();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}