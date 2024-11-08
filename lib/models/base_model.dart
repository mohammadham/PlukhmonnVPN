import 'package:flutter/material.dart';
import 'package:sail/models/page_state.dart';
import 'package:sail/utils/common_util.dart';

class BaseModel extends ChangeNotifier {
  PageState pageState = PageState.loading;
  bool _isDispose = false;
  late String errorMessage;

  bool get isDispose => _isDispose;

  @override
  void notifyListeners() {
<<<<<<< HEAD
<<<<<<< Updated upstream
    //print("view model notifyListeners");
=======
    // print("view model notifyListeners");
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
    // print("view model notifyListeners");
=======
    //print("view model notifyListeners");
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    if (!_isDispose) {
      super.notifyListeners();
    }
  }

  void errorNotify(String error) {
    pageState = PageState.error;
    errorMessage = error;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDispose = true;
    //print("view model dispose");
    super.dispose();
  }
}
