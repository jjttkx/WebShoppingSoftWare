//登录接口API
import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/utils/DioRequest.dart';
import 'package:hm_shop/viewmodels/user.dart';

Future<UserInfo> loginAPI(Map<String, dynamic> data) async {
  return UserInfo.fromJSON(
    await dioRequest.post(HttpsConstants.LOGIN, data: data),
  );
}


Future<UserInfo> getUserInfoAPI() async{
  return UserInfo.fromJSON(
    await dioRequest.get(HttpsConstants.USER_PROFILE),
  );
}