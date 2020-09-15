import 'dart:collection';

import 'package:flutter_login_ui/modelo/denuncias.dart';
import 'package:flutter/cupertino.dart';

class DenunciaNotifier with ChangeNotifier {
  List<Denuncia> _denunciaList = [];
  Denuncia _currentDenuncia;

  UnmodifiableListView<Denuncia> get denunciaList => UnmodifiableListView(_denunciaList);

  Denuncia get currentDenuncia => _currentDenuncia;

  set denunciaList(List<Denuncia> denunciaList) {
    _denunciaList = denunciaList;
    notifyListeners();
  }

  set currentDenuncia(Denuncia denuncia) {
    _currentDenuncia = denuncia;
    notifyListeners();
  }

  addDenuncia(Denuncia denuncia) {
    _denunciaList.insert(0, denuncia);
    notifyListeners();
  }

  deleteDenuncia(Denuncia Denuncia) {
    _denunciaList.removeWhere((_denuncia) => _denuncia.id == Denuncia.id);
    notifyListeners();
  }
}