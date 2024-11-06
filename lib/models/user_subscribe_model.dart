import 'package:sail/constant/app_strings.dart';
import 'package:sail/entity/user_subscribe_entity.dart';
import 'package:sail/http/api/AppSettings.dart';
import 'package:sail/http/api/AppSettingsManager.dart';
import 'package:sail/models/base_model.dart';
import 'package:sail/service/user_service.dart';
import 'package:sail/utils/shared_preferences_util.dart';

class UserSubscribeModel extends BaseModel {
  UserSubscribeEntity? _userSubscribeEntity;

  final UserService _userService = UserService();
  AppSettings? _settings;
  // UserSubscribeModel({this.setAppSettings});
  UserSubscribeEntity? get userSubscribeEntity => _userSubscribeEntity;
  AppSettings? get appSettings => _settings;
  void setAppSettings (AppSettings input)
  {
    _settings=input;
    _userService.setAppSettings=input;
  }

  Future<bool> getUserSubscribe({bool forceRefresh = false}) async {
    bool result = false;

    // Map<String, dynamic>? data = await SharedPreferencesUtil.getInstance() ?.getMap(AppStrings.userSubscribe);
    Map<String, dynamic>? data;
    if (data == null || data.isEmpty || forceRefresh) {
      var usersub = await _userService.userSubscribe();
      if(usersub != null )
        {
          setUserSubscribeEntity(usersub);
        }else{
        setUserSubscribeEntity(await _userService.userFreeSubscribe());
      }
    } else {
      _userSubscribeEntity = UserSubscribeEntity.fromMap(data);
    }

    notifyListeners();

    result = true;

    return result;
  }

  setUserSubscribeEntity(UserSubscribeEntity? userSubscribeEntity) {
    _userSubscribeEntity = userSubscribeEntity;

    _saveUserSubscribe();
  }

  _saveUserSubscribe() async {
    SharedPreferencesUtil? sharedPreferencesUtil =
        SharedPreferencesUtil.getInstance();

    await sharedPreferencesUtil?.setMap(
        AppStrings.userSubscribe, _userSubscribeEntity?.toMap());
  }
}
