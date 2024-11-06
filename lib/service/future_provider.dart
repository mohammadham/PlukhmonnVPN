import 'package:sail/entity/user_entity.dart';
import 'package:sail/models/invite_code_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/service/invite_code_service.dart';
import 'package:sail/service/user_service.dart';




import 'package:sail/utils/storage/token_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


// 创建一个 FutureProvider 来管理邀请码列表
final inviteCodesProvider = FutureProvider<List<InviteCode>>((ref) async {
  final accessToken = await getToken(); // 从存储中获取 accessToken
  if (accessToken == null) {
    throw Exception('No access token found.');
  }
  return InviteCodeService().fetchInviteCodes(accessToken);
});

// 定义 userInfoProvider
final userTokenInfoProvider = FutureProvider<UserEntity?>((ref) async {
  // 获取存储的访问令牌
  final accessToken = await getToken();
  
  // 如果令牌为空，返回空值
  if (accessToken == null) {
    return null;
  }
  
  // 调用 AuthService 获取用户信息
  // return await UserService().fetchUserInfo(accessToken);
  return await UserService().info();
});
