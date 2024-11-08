import 'dart:convert';

import 'package:sail/constant/app_urls.dart';
import 'package:sail/entity/server_entity.dart';
import 'package:sail/utils/http_util.dart';
import 'package:sail/entity/v2ray_entity.dart';
import 'package:sail/entity/v2ray_config_entity.dart';

class ServerService {
  Future<List<ServerEntity>?> server() {
    return HttpUtil.instance.get(AppUrls.server).then((result) {
      if(result != null && result is Map<String,dynamic> )
        {
          if(result['data'] != null && result['data'] != '')
            {
              print('[info] server =='+jsonEncode(result).toString());
              return serverEntityFromList(result['data']);
            }
        }
      return [];

    });
  }
<<<<<<< HEAD
<<<<<<< Updated upstream
  Future<List<ServerEntity>?> freeServer() {
=======
  Future<Map<String, dynamic>> freeServer() {
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
  Future<Map<String, dynamic>> freeServer() {
=======
  Future<List<ServerEntity>?> freeServer() {
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    print ('[info] server free address = '+AppUrls.freeServer);
    return HttpUtil.instance.get(AppUrls.freeServer).then((result) {
      if(result != null  )
      {
        if(result['data'] != null && result['data'] != '')
        {
          // print('[info] server =='+jsonEncode(utf8.decode(base64.decode(result))).toString());
          print('[info] server =='+jsonEncode(result).toString());
          List<V2RayConfig> v2ray = [];
          List<ServerEntity> xboard = [];
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
          var data = [];
          // var res=null;
          if(!(result['data'] is String ))
            {

=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
          // var res=null;
          if(!(result['data'] is String ))
            {
              var data = [];
<<<<<<< HEAD
=======
          var data = [];
          // var res=null;
          if(!(result['data'] is String ))
            {

>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
              // data = result['data'];
              // for(int i=0;i<data.length;i++)
              //   {
              //     try{
              //       if(data[i] is String) {
              //         v2ray.add(V2RayConfig.fromV2RayConfigString(data[i]));
              //         xboard.add(V2RayConfig.serverEntityFromVlessLink(data[i],i));
              //       }else if(data[i] is Map<String,dynamic>)
              //         {
              //           v2ray.add(V2RayConfig.fromMap(data[i]));
              //         }
              //     }catch(e)
              //     {
              //       print('[wrong type] '+e.toString());
              //     }
              //   }
              try{
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
                print('[info] server =='+result['data'].runtimeType.toString());
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
                print('[info] server =='+result['data'].runtimeType.toString());
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
                if(result['data'] is List<String>) {

                  v2ray = V2RayConfig.parseConfigList(result['data']);
                  xboard= V2RayConfig.parseServerConfigList(result['data']);
                  data = V2RayEntity.parseConfigList(result["data"]);
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
                }else if(result['data'] is List<Map<String,dynamic>> ){
                  final freeServers = result['data'] ;//as List<Map<String,dynamic>>;
                  // print('[info] servers list type =='+freeServers.runtimeType.toString() +" ***  "+freeServers.toString());
                  v2ray = V2RayConfig.parseConfigList(V2RayEntity.parseStringConfigList(freeServers));
                  xboard= V2RayConfig.parseServerConfigList(V2RayEntity.parseStringConfigList(freeServers));
                  data = V2RayEntity.parseServerConfigList(freeServers);
                }else if( result['data'] is List<dynamic>){
                  final freeServers = result['data'] ;//as List<Map<String,dynamic>>;
                  print('[info] servers list type =='+V2RayEntity.parseStringConfigListDynamic(freeServers).toString());
                  v2ray = V2RayConfig.parseConfigList(V2RayEntity.parseStringConfigListDynamic(freeServers));
                  xboard= V2RayConfig.parseServerConfigList(V2RayEntity.parseStringConfigListDynamic(freeServers));
                  data = V2RayEntity.parseConfigList(V2RayEntity.parseStringConfigListDynamic(freeServers));
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
                }else if(result['data'] is List<Map<String,dynamic>>){
                  v2ray = V2RayConfig.parseConfigList(V2RayEntity.parseStringConfigList(result['data']));
                  xboard= V2RayConfig.parseServerConfigList(V2RayEntity.parseStringConfigList(result['data']));
                  data = V2RayEntity.parseServerConfigList(result["data"]);
<<<<<<< HEAD
=======
                }else if(result['data'] is List<Map<String,dynamic>> ){
                  final freeServers = result['data'] ;//as List<Map<String,dynamic>>;
                  // print('[info] servers list type =='+freeServers.runtimeType.toString() +" ***  "+freeServers.toString());
                  v2ray = V2RayConfig.parseConfigList(V2RayEntity.parseStringConfigList(freeServers));
                  xboard= V2RayConfig.parseServerConfigList(V2RayEntity.parseStringConfigList(freeServers));
                  data = V2RayEntity.parseServerConfigList(freeServers);
                }else if( result['data'] is List<dynamic>){
                  final freeServers = result['data'] ;//as List<Map<String,dynamic>>;
                  print('[info] servers list type =='+V2RayEntity.parseStringConfigListDynamic(freeServers).toString());
                  v2ray = V2RayConfig.parseConfigList(V2RayEntity.parseStringConfigListDynamic(freeServers));
                  xboard= V2RayConfig.parseServerConfigList(V2RayEntity.parseStringConfigListDynamic(freeServers));
                  data = V2RayEntity.parseConfigList(V2RayEntity.parseStringConfigListDynamic(freeServers));
>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
                }
              }catch(e)
              {
                print('[wrong type] '+e.toString());
              }
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
            }else{
            try{
              print('[info] server =='+result['data'].runtimeType.toString());
              final freeServers = jsonDecode(result['data']);
              if(freeServers is List<String>) {

                v2ray = V2RayConfig.parseConfigList(result['data']);
                xboard= V2RayConfig.parseServerConfigList(result['data']);
                data = V2RayEntity.parseConfigList(result["data"]);
              }else if(freeServers is List<Map<String,dynamic>>){
                v2ray = V2RayConfig.parseConfigList(V2RayEntity.parseStringConfigList(result['data']));
                xboard= V2RayConfig.parseServerConfigList(V2RayEntity.parseStringConfigList(result['data']));
                data = V2RayEntity.parseServerConfigList(result["data"]);
              }
            }catch(e)
            {
              print('[wrong type string] '+e.toString());
            }

          }
          return {
            'servers': xboard,
            'data': data
          };
        }
      }
      return {
        'servers': [],
        'data': []
      };
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
            }
          return serverEntityFromList(xboard);
        }
      }
      return [];
<<<<<<< HEAD
=======
            }else{
            try{
              print('[info] server =='+result['data'].runtimeType.toString());
              final freeServers = jsonDecode(result['data']);
              if(freeServers is List<String>) {

                v2ray = V2RayConfig.parseConfigList(result['data']);
                xboard= V2RayConfig.parseServerConfigList(result['data']);
                data = V2RayEntity.parseConfigList(result["data"]);
              }else if(freeServers is List<Map<String,dynamic>>){
                v2ray = V2RayConfig.parseConfigList(V2RayEntity.parseStringConfigList(result['data']));
                xboard= V2RayConfig.parseServerConfigList(V2RayEntity.parseStringConfigList(result['data']));
                data = V2RayEntity.parseServerConfigList(result["data"]);
              }
            }catch(e)
            {
              print('[wrong type string] '+e.toString());
            }

          }
          return {
            'servers': xboard,
            'data': data
          };
        }
      }
      return {
        'servers': [],
        'data': []
      };
>>>>>>> Stashed changes
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
    });
  }
}
