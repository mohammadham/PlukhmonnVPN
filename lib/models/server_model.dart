import 'dart:convert';
import 'dart:io';

import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';
import 'package:sail/entity/v2ray_config_entity.dart';
import 'package:sail/resources/app_strings.dart';
import 'package:sail/entity/server_entity.dart';
import 'package:sail/models/base_model.dart';
import 'package:sail/service/server_service.dart';
import 'package:sail/utils/shared_preferences_util.dart';
import 'package:sail/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PingType { ping, tcp }

class ServerModel extends BaseModel {
  List<ServerEntity> _serverEntityList = [];
  List<V2RayEntity> _serverFreeEntityList = [];
  ServerEntity? _selectServerEntity;
  int _selectServerIndex = 0;
  bool isFreeServer = false;
  bool freeServerLikeIsUpdate = false;

  final ServerService _serverService = ServerService();

  List<ServerEntity> get serverEntityList => _serverEntityList;

  ServerEntity? get selectServerEntity => _selectServerEntity;

  int get selectServerIndex => _selectServerIndex;

  getServerList({bool forceRefresh = false}) async {
    bool result = false;

    List<dynamic> data = await SharedPreferencesUtil.getInstance()
            ?.getList(AppStrings.serverNode) ??
        [];
    List<dynamic> TfreeData = await SharedPreferencesUtil.getInstance()
        ?.getList(AppStrings.freeServers) ??
        [];
    List<dynamic> newData =
        List.from(data.map((e) => Map<String, dynamic>.from(jsonDecode(e))));
    List<dynamic> freeData =
      List.from(TfreeData.map((e) => Map<String, dynamic>.from(jsonDecode(e))));
    bool isFree = await SharedPreferencesUtil.getInstance()
        ?.getBool(AppStrings.isFreeAccess) ??
        this.isFreeServer;
    print("[info] server data = $newData");
    // result = false;
    if (newData.isEmpty || forceRefresh) {
      var servers ;
      if(!isFree) servers= await _serverService.server();

      if(servers != null && servers != [] && servers.isNotEmpty  && servers != {"data":[]} ){
        print("Xboard servers"+servers.toString());
      setServerEntityList(servers);
        result = true;
        await SharedPreferencesUtil.getInstance()?.setBool(AppStrings.isFreeAccess, false);
        await setFreeServerEntityList([]);
        this.isFreeServer = false;
      }else{
        final response = await _serverService.freeServer();
         var servers = response['servers'];
         List<Map<String, dynamic>> data = response['data'];
        // print(data.toString());
        // print("Free servers"+servers.toString());
        if(servers != null && servers != [] && servers is List<ServerEntity> ) {
          setServerEntityList(servers);
          await setFreeServerEntityList(V2RayEntity.parseServerConfigList( data));
          result = true;
          //need to set is free version
          this.isFreeServer = true;
          await SharedPreferencesUtil.getInstance()?.setBool(AppStrings.isFreeAccess, true);

        }
      }




    } else {
      _serverEntityList = serverEntityFromList(newData);
      if(isFree && freeData.isNotEmpty) {
        _serverFreeEntityList = v2serverEntityFromList(freeData);
      }


      result = true;
    }
    notifyListeners();




    return result;
  }

  void pingAll() async {
    for (int i = 0; i < _serverEntityList.length; i++) {
      var duration = const Duration(milliseconds: 300);
      await Future.delayed(duration);
      ping(i);
    }
    freeServerLikeIsUpdate = true;
    updatePingLike();
  }
  ///like and dislike of a config for manage in server side
  void updatePingLike() async {
    if(isFreeServer && freeServerLikeIsUpdate){
      final servers= await _serverService.updateLikeDislike(_serverFreeEntityList);
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
            if(serverEntityList[index].ping!
                .inSeconds >
                10)
            {
              if(_serverFreeEntityList != null && _serverFreeEntityList.isNotEmpty && !this.freeServerLikeIsUpdate)
              { _serverFreeEntityList![index]!.dislike =_serverFreeEntityList![index]!.dislike+1; }

            }else{
              if(_serverFreeEntityList != null && _serverFreeEntityList.isNotEmpty && !this.freeServerLikeIsUpdate)
              { _serverFreeEntityList![index]!.like =_serverFreeEntityList![index]!.like+1; }
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
          if(serverEntityList[index].ping!
              .inSeconds >
              10)
          {
            if(_serverFreeEntityList != null && _serverFreeEntityList.isNotEmpty && !this.freeServerLikeIsUpdate)
            { _serverFreeEntityList![index]!.dislike =_serverFreeEntityList![index]!.dislike+1; }

          }else{
            if(_serverFreeEntityList != null && _serverFreeEntityList.isNotEmpty && !this.freeServerLikeIsUpdate)
            { _serverFreeEntityList![index]!.like =_serverFreeEntityList![index]!.like+1; }
          }
          notifyListeners();

          return duration;
        }).catchError((error) {
          var duration = const Duration(minutes: 1);
          _serverEntityList[index].ping = duration;
          if(serverEntityList[index].ping!
              .inSeconds >
              10)
          {
            if(_serverFreeEntityList != null && _serverFreeEntityList.isNotEmpty && !this.freeServerLikeIsUpdate)
            { _serverFreeEntityList![index]!.dislike =_serverFreeEntityList![index]!.dislike+1; }

          }else{
            if(_serverFreeEntityList != null && _serverFreeEntityList.isNotEmpty && !this.freeServerLikeIsUpdate)
            { _serverFreeEntityList![index]!.like =_serverFreeEntityList![index]!.like+1; }
          }
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
    if(_selectServerEntity != null)
      {
        final pref = await SharedPreferences.getInstance();
        pref.setInt(AppStrings.freeServerIndex, (_selectServerEntity!.id) - 1 ?? 0);
      }
    return _selectServerEntity;
  }

  setServerEntityList(List<ServerEntity> serverEntityList) {
    _serverEntityList = serverEntityList;

    _saveServerEntityList();
  }
  setFreeServerEntityList(List<V2RayEntity> serverEntityList) {
    _serverFreeEntityList = serverEntityList;

    _saveFreeServerEntityList();
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
  _saveFreeServerEntityList() async {
    SharedPreferencesUtil? sharedPreferencesUtil =
    SharedPreferencesUtil.getInstance();

    await sharedPreferencesUtil?.setList(
        AppStrings.freeServers, _serverFreeEntityList);
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
