import 'package:flutter/material.dart';

class ToastUtils {
  //阀门控制
  static bool showLoading = false;
  static void showToast(BuildContext context, String msg) {
    if(ToastUtils.showLoading) return;
    ToastUtils.showLoading = true;
    Future.delayed(Duration(seconds: 2), () {
      ToastUtils.showLoading = false;
    });
    //数据获取成功
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 180,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text(msg ?? "刷新成功", textAlign: TextAlign.center),
      ),
    );
  }
}
