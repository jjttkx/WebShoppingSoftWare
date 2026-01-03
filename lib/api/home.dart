//封装一个api，目的是返回业务侧要的数据结构
import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/utils/DioRequest.dart';
import 'package:hm_shop/viewmodels/home.dart';

Future<List<BannerItem>> getBannerListAPI() async {
  //返回请求
  print('正在请求 API: ${HttpsConstants.BANNER_LIST}');
  final result = await dioRequest.get(HttpsConstants.BANNER_LIST);
  print('API 返回结果: $result');
  return ((result) as List).map((item) {
    return BannerItem.fromJson(item as Map<String, dynamic>);
  }).toList();
}
