import 'package:sail/constant/app_urls.dart';
import 'package:sail/resources/app_strings.dart';
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

    Map<String, dynamic>? data = await SharedPreferencesUtil.getInstance() ?.getMap(AppStrings.userSubscribe);
    // Map<String, dynamic>? data;
    if (data != null && data.isNotEmpty && !forceRefresh && data != [] ){
      if(data['expired_at'] != null  && data['expired_at'] != 0 && data['plan_id'] != null && data['plan_id'] != 0    ) {
        print(data);
        if (DateTime
            .now()
            .millisecond < int.parse(data['expired_at'].toString())) {
          _userSubscribeEntity = UserSubscribeEntity.fromMap(data);
          AppUrls.updateFreeServer(data['subscribe_url']);
          result = true;
          notifyListeners();



          return result;
        }
      }
    }
    
    // if((data == null || data.isEmpty || forceRefresh || data == [] ) || !result){
      var usersub;
      try{usersub = await _userService.userSubscribe();
      }catch(e){
        print(e);
        usersub = null;
      }
      if(usersub != null )
        {
          setUserSubscribeEntity(usersub);
          result = true;
          await SharedPreferencesUtil.getInstance()?.setBool(AppStrings.isFreeAccess, false);
        }else{
        UserSubscribeEntity? userdata = await _userService.userFreeSubscribe();
        AppUrls.updateFreeServer(userdata!.subscribeUrl);
        setUserSubscribeEntity(userdata);
        result = true;
        await SharedPreferencesUtil.getInstance()?.setBool(AppStrings.isFreeAccess, true);
      }
    // }

    notifyListeners();



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
