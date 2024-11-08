import 'dart:convert';
import 'dart:io';

import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';
<<<<<<< HEAD
<<<<<<< Updated upstream
import 'package:sail/constant/app_strings.dart';
=======
import 'package:sail/resources/app_strings.dart';
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
import 'package:sail/resources/app_strings.dart';
=======
import 'package:sail/constant/app_strings.dart';
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
import 'package:sail/entity/server_entity.dart';
import 'package:sail/models/base_model.dart';
import 'package:sail/service/server_service.dart';
import 'package:sail/utils/shared_preferences_util.dart';
import 'package:sail/utils/common_util.dart';
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55

enum PingType { ping, tcp }

class ServerModel extends BaseModel {
  List<ServerEntity> _serverEntityList = [];
  ServerEntity? _selectServerEntity;
  int _selectServerIndex = 0;

  final ServerService _serverService = ServerService();

  List<ServerEntity> get serverEntityList => _serverEntityList;

  ServerEntity? get selectServerEntity => _selectServerEntity;

  int get selectServerIndex => _selectServerIndex;

  getServerList({bool forceRefresh = false}) async {
    bool result = false;

    List<dynamic> data = await SharedPreferencesUtil.getInstance()
            ?.getList(AppStrings.serverNode) ??
        [];
    List<dynamic> newData =
        List.from(data.map((e) => Map<String, dynamic>.from(jsonDecode(e))));
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
    // bool isFree = await SharedPreferencesUtil.getInstance()
    //     ?.getBool(AppStrings.isFreeAccess) ??
    //     false;
    print("[info] server data = $newData");
    // result = false;
    if (newData.isEmpty || forceRefresh) {
      var servers = await _serverService.server();
      var data = [];
      if(servers != null && servers != [] && servers.isNotEmpty  && servers != {"data":[]} ){
        print("Xboard servers"+servers.toString());
      setServerEntityList(servers);
        await SharedPreferencesUtil.getInstance()?.setBool(AppStrings.isFreeAccess, false);
        await SharedPreferencesUtil.getInstance()?.setList(AppStrings.freeServers, []);
      }else{
        final response = await _serverService.freeServer();
         servers = response['servers'];
         data = response['data'];
        // print(data.toString());
        // print("Free servers"+servers.toString());
        if(servers != null && servers != [] ) {
          setServerEntityList(servers);
          //need to set is free version
          await SharedPreferencesUtil.getInstance()?.setBool(AppStrings.isFreeAccess, true);
          await SharedPreferencesUtil.getInstance()?.setList(AppStrings.freeServers, data);
        }
      }



      result = true;
    } else {
      _serverEntityList = serverEntityFromList(newData);


      result = true;
    }
    notifyListeners();



=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55

    print("[info] server data = $newData");
    if (newData.isEmpty || forceRefresh) {
      var servers = await _serverService.server();
      if(servers != null && servers != [] ){
      setServerEntityList(servers);
      }else{
        servers = await _serverService.freeServer();
        if(servers != null && servers != [] ) {
          setServerEntityList(servers);
        }
      }
    } else {
      _serverEntityList = serverEntityFromList(newData);
    }

    notifyListeners();

    result = true;
<<<<<<< HEAD
=======
    // bool isFree = await SharedPreferencesUtil.getInstance()
    //     ?.getBool(AppStrings.isFreeAccess) ??
    //     false;
    print("[info] server data = $newData");
    // result = false;
    if (newData.isEmpty || forceRefresh) {
      var servers = await _serverService.server();
      var data = [];
      if(servers != null && servers != [] && servers.isNotEmpty  && servers != {"data":[]} ){
        print("Xboard servers"+servers.toString());
      setServerEntityList(servers);
        await SharedPreferencesUtil.getInstance()?.setBool(AppStrings.isFreeAccess, false);
        await SharedPreferencesUtil.getInstance()?.setList(AppStrings.freeServers, []);
      }else{
        final response = await _serverService.freeServer();
         servers = response['servers'];
         data = response['data'];
        // print(data.toString());
        // print("Free servers"+servers.toString());
        if(servers != null && servers != [] ) {
          setServerEntityList(servers);
          //need to set is free version
          await SharedPreferencesUtil.getInstance()?.setBool(AppStrings.isFreeAccess, true);
          await SharedPreferencesUtil.getInstance()?.setList(AppStrings.freeServers, data);
        }
      }



      result = true;
    } else {
      _serverEntityList = serverEntityFromList(newData);


      result = true;
    }
    notifyListeners();



>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55

    return result;
  }

  void pingAll() async {
    for (int i = 0; i < _serverEntityList.length; i++) {
      var duration = const Duration(milliseconds: 300);
      await Future.delayed(duration);
      ping(i);
    }
  }

  void ping(int index, {PingType type = PingType.tcp}) {
    ServerEntity serverEntity = _serverEntityList[index];
    String host = serverEntity.host;
    int serverPort = serverEntity.port;

    //print("host=$host");
    //print("serverPort=$serverPort");

    switch (type) {
      case PingType.ping:
        try {
          final ping =
              Ping(host, count: 1, timeout: 1.0, interval: 1.0, ipv6: false);
          ping.stream.listen((event) {
            print(event);
            if (event.error != null) {
              var duration = const Duration(minutes: 1);
              _serverEntityList[index].ping = duration;
            } else if (event.response != null) {
              _serverEntityList[index].ping = event.response?.time;
            }
            notifyListeners();

            ping.stop();
          });
        } catch (e) {
          rethrow;
        }
        break;
      case PingType.tcp:
        Stopwatch stopwatch = Stopwatch()..start();

        Socket.connect(host, serverPort, timeout: const Duration(seconds: 3))
            .then((socket) {
          socket.destroy();
          var duration = stopwatch.elapsed;
          _serverEntityList[index].ping = duration;

          notifyListeners();

          return duration;
        }).catchError((error) {
          var duration = const Duration(minutes: 1);
          _serverEntityList[index].ping = duration;

          throw error;
        });
        break;
      default:
        throw Error();
    }
  }

  getSelectServer() async {
    Map<String, dynamic> data = await SharedPreferencesUtil.getInstance()
            ?.getMap(AppStrings.selectServer) ??
        <String, dynamic>{};
    int index = int.parse(await SharedPreferencesUtil.getInstance()
            ?.getString(AppStrings.selectServerIndex) ??
        '0');

    if (data.isEmpty) {
      return null;
    }

    _selectServerEntity = ServerEntity.fromMap(data);
    _selectServerIndex = index;

    notifyListeners();
<<<<<<< HEAD
<<<<<<< Updated upstream

=======
    if(_selectServerEntity != null)
      {
        final pref = await SharedPreferences.getInstance();
        pref.setInt(AppStrings.freeServerIndex, (_selectServerEntity!.id) - 1 ?? 0);
      }
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
    if(_selectServerEntity != null)
      {
        final pref = await SharedPreferences.getInstance();
        pref.setInt(AppStrings.freeServerIndex, (_selectServerEntity!.id) - 1 ?? 0);
      }
=======

>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    return _selectServerEntity;
  }

  setServerEntityList(List<ServerEntity> serverEntityList) {
    _serverEntityList = serverEntityList;

    _saveServerEntityList();
  }

  setSelectServerEntity(ServerEntity selectServerEntity) {
    _selectServerEntity = selectServerEntity;

    _saveSelectServerEntity();

    notifyListeners();
  }

  setSelectServerIndex(int index) {
    _selectServerIndex = index;

    _saveSelectServerIndex();

    notifyListeners();
  }

  _saveServerEntityList() async {
    SharedPreferencesUtil? sharedPreferencesUtil =
        SharedPreferencesUtil.getInstance();

    await sharedPreferencesUtil?.setList(
        AppStrings.serverNode, _serverEntityList);
  }

  _saveSelectServerEntity() async {
    SharedPreferencesUtil? sharedPreferencesUtil =
        SharedPreferencesUtil.getInstance();

    await sharedPreferencesUtil?.setMap(
        AppStrings.selectServer, _selectServerEntity!.toMap());
  }

  _saveSelectServerIndex() async {
    SharedPreferencesUtil? sharedPreferencesUtil =
        SharedPreferencesUtil.getInstance();

    await sharedPreferencesUtil?.setString(
        AppStrings.selectServerIndex, _selectServerIndex.toString());
  }
}
