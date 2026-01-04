//封装一个api，目的是返回业务侧要的数据结构
import 'package:hm_shop/constants/index.dart';
import 'package:hm_shop/utils/DioRequest.dart';
import 'package:hm_shop/viewmodels/home.dart';

Future<List<BannerItem>> getBannerListAPI() async {
  //返回请求
  final result = await dioRequest.get(HttpsConstants.BANNER_LIST);
  return ((result) as List).map((item) {
    return BannerItem.fromJson(item as Map<String, dynamic>);
  }).toList();
}

//分类列表
Future<List<CategoryItem>> getCategoryListAPI() async {
  //返回请求
  final result = await dioRequest.get(HttpsConstants.CATEGORY_LIST);
  return ((result) as List).map((item) {
    return CategoryItem.fromJson(item as Map<String, dynamic>);
  }).toList();
}

//特惠推荐
Future<SpecialRecommendResult> getProductListAPI() async {
  //返回请求
  final result = await dioRequest.get(HttpsConstants.PRODUCT_LIST);
  final specialRecommendResult = SpecialRecommendResult.formJSON(result);
  return specialRecommendResult;
}
