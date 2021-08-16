import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';

class TypeOfFilters with ChangeNotifier {
  String _ordonare = 'Noi';
  String _locatie = 'Oriunde';
  String _judet = 'Oriunde';

  int defaultNumber = 2;

  // crescator => 'pret', descending: false
  // descrescator => 'pret', descending: true
  // noi => 'date', descending: true

  set setDefaultNumber(int newValue) {
    defaultNumber = newValue;
    notifyListeners();
  }

  set setOrdonare(String newValue) {
    _ordonare = newValue;
    notifyListeners();
  }

  set setLocatie(String newValue) {
    _locatie = newValue;
    notifyListeners();
  }

  set setJudet(String newValue) {
    _judet = newValue;
    notifyListeners();
  }

  getVariableName() => _ordonare.toLowerCase() == 'noi' ? 'date' : 'pret';

  getBoolForValue() {
    if (_ordonare.toLowerCase() == 'noi') return true;
    if (removeDiacritics(_ordonare.toLowerCase()) == 'crescator') return false;
    return true;
  }

  get ordonare => _ordonare;

  get locatie => _locatie;

  get judet => _judet;
}
