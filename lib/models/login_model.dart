import 'package:sail/constant/app_urls.dart';
import 'package:sail/models/base_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/service/user_service.dart';
import 'dart:convert';
class LoginModel extends BaseModel {
  final UserService _userService = UserService();
  final UserModel _userModel;

  LoginModel(this._userModel);
  void logInfo(String message) => print('[INFO] $message');
  // 登陆方法
  login(String? account, String? passWord) async {
    var parameters = {'email': account, 'password': passWord};

    return _userService.login(parameters)?.then((loginEntity) async {
      if(loginEntity != null)
      {
        _userModel.setToken(loginEntity);
      return _userService.info();
      }


    }).then((userEntity) {
      _userModel.setUserInfo(userEntity);
      notifyListeners();

      return userEntity;
    });
  }
}
