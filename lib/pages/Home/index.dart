import 'package:flutter/material.dart';
import 'package:hm_shop/api/home.dart';
import 'package:hm_shop/components/Home/HmCategory.dart';
import 'package:hm_shop/components/Home/HmHot.dart';
import 'package:hm_shop/components/Home/HmMoreList.dart';
import 'package:hm_shop/components/Home/HmSlider.dart';
import 'package:hm_shop/components/Home/HmSuggestion.dart';
import 'package:hm_shop/viewmodels/home.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<BannerItem> _bannerList = [
    // BannerItem(
    //   id: '1',
    //   imgUrl: 'https://img.shetu66.com/2023/10/10/1696951323342030.png',
    // ),
    // BannerItem(
    //   id: '2',
    //   imgUrl: 'https://img.shetu66.com/2023/10/27/1698419482365679.png',
    // ),
    // BannerItem(
    //   id: '3',
    //   imgUrl: 'https://img.shetu66.com/2023/10/27/1698419126335313.png',
    // ),
  ];
  //https://pic.nximg.cn/file/20220419/17964847_095055490109_2.jpg
  //https://img.shetu66.com/2023/10/27/1698419482365679.png
  //https://pic.nximg.cn/file/20230715/27640063_232650497105_2.jpg

  List<Widget> _getScrollChildren() {
    return [
      SliverToBoxAdapter(child: HmSlider(bannerList: _bannerList)),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      //SliverGrid SliverList只能纵向排列
      //ListView
      SliverToBoxAdapter(child: HmCategory()),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(child: HmSuggestion()),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(child: HmHot()),
              SizedBox(width: 10),
              Expanded(child: HmHot()),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      HmMoreList(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _getBannerList();
  }

  void _getBannerList() async {
    try {
      print('开始请求轮播图数据...');
      _bannerList = await getBannerListAPI();
      print('轮播图数据获取成功: ${_bannerList.length} 条');
      setState(() {});
    } catch (e) {
      print('获取轮播图数据失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: _getScrollChildren()); //sliver家族内容
  }
}
