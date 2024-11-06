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
  Future<List<ServerEntity>?> freeServer() {
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
          // var res=null;
          if(!(result['data'] is String ))
            {
              var data = [];
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
                if(result['data'] is List<String>) {

                  v2ray = V2RayConfig.parseConfigList(result['data']);
                  xboard= V2RayConfig.parseServerConfigList(result['data']);
                  data = V2RayEntity.parseConfigList(result["data"]);
                }else if(result['data'] is List<Map<String,dynamic>>){
                  v2ray = V2RayConfig.parseConfigList(V2RayEntity.parseStringConfigList(result['data']));
                  xboard= V2RayConfig.parseServerConfigList(V2RayEntity.parseStringConfigList(result['data']));
                  data = V2RayEntity.parseServerConfigList(result["data"]);
                }
              }catch(e)
              {
                print('[wrong type] '+e.toString());
              }
            }
          return serverEntityFromList(xboard);
        }
      }
      return [];
    });
  }
}
