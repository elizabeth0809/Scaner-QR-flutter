import 'package:flutter/cupertino.dart';

class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt = 0;
  int get selectedMenuOpt {
    return this._selectedMenuOpt;
  }

  set selectedMenuOpt(int i) {
    this._selectedMenuOpt = i;
    notifyListeners();
  }
}
