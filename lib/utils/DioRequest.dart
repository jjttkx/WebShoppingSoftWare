//基于Dio二次封装

import 'package:dio/dio.dart';
import 'package:hm_shop/constants/index.dart';

class DioRequest {
  final _dio = Dio();
  //基础地址拦截器
  DioRequest() {
    _dio.options
      ..baseUrl = GlobalConstants.BASE_URL
      ..connectTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
      ..sendTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
      ..receiveTimeout = Duration(seconds: GlobalConstants.TIME_OUT);
    //拦截器
    _addInterceptor();
  }
  void _addInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          handler.next(request);
        },
        onResponse: (response, handler) {
          if (response.statusCode! >= 200 && response.statusCode! <= 300) {
            handler.next(response);
            return;
          }
          handler.reject(DioException(requestOptions: response.requestOptions));
        },
        onError: (error, handler) {
          handler.reject(error);
        },
      ),
    );
  }

  get(String url, {Map<String, dynamic>? params}) async {
    print('Dio 请求: $url, 参数: $params');
    return _handleResponse(_dio.get(url, queryParameters: params));
  }

  //进一步处理返回结果的函数
  _handleResponse(Future<Response<dynamic>> task) async {
    try {
      Response<dynamic> res = await task;
      print('Dio 响应状态: ${res.statusCode}');
      print('Dio 响应数据: ${res.data}');
      final data = res.data as Map<String, dynamic>; //data才是我们真实的接口返回的数据
      if (data["code"] == GlobalConstants.SUCCESS_CODE) {
        //才认定 http状态和业务状态均正常，就可以正常的放行通过
        print('业务状态码匹配成功，返回数据: ${data["result"]}');
        return data["result"];
      }
      print('业务状态码不匹配: ${data["code"]}');
      //抛出异常
      throw Exception(data["msg"] ?? "数据加载异常");
    } catch (e) {
      print('网络请求异常: $e');
      throw Exception(e);
    }
  }
}

//单例对象
final dioRequest = DioRequest();

//dio请求工具发出请求，返回的数据 Response<dynamic>.data
//把所有的接口的data解放出来，拿到真正的数据，要判断业务逻辑是不是等于1
