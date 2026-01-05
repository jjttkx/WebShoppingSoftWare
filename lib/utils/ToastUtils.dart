import 'package:flutter/material.dart';

class ToastUtils {
  static void showToast(BuildContext context,String msg) {
    //数据获取成功
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 120,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text(msg?? "刷新成功", textAlign: TextAlign.center),
      ),
    );
  }
}