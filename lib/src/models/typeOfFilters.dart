import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TypeOfFilters with ChangeNotifier {
  String _ordonare = 'Noi';
  String _locatie = 'Oriunde';

  set setOrdonare(String newValue) {
    _ordonare = newValue;
    notifyListeners();
  }

  set setLocatie(String newValue) {
    _locatie = newValue;
    notifyListeners();
  }

  getVariableName() => _ordonare.toLowerCase() == 'noi' ? 'date' : 'pret';

  getBoolForValue() {
    if (_ordonare.toLowerCase() == 'noi') return true;
    if (_ordonare.toLowerCase() == 'crescator') return true;
    return false;
  }

  get ordonare => _ordonare;

  get locatie => _locatie;
}
