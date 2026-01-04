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
  //分类列表
  List<CategoryItem> _categoryList = [];
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
      SliverToBoxAdapter(child: HmCategory(categoryList: _categoryList)),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: HmSuggestion(specialRecommendResult: _specialRecommendResult),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: HmHot(result: _inVogueResult, type: "hot"),
              ),
              SizedBox(width: 10),
              Expanded(
                child: HmHot(result: _oneStopResult, type: "step"),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      HmMoreList(),
    ];
  }

  SpecialRecommendResult _specialRecommendResult = SpecialRecommendResult(
    id: '',
    title: '',
    subTypes: [],
  );

  // 热榜推荐
  SpecialRecommendResult _inVogueResult = SpecialRecommendResult(
    id: "",
    title: "",
    subTypes: [],
  );
  // 一站式推荐
  SpecialRecommendResult _oneStopResult = SpecialRecommendResult(
    id: '',
    title: "",
    subTypes: [],
  );



  @override
  void initState() {
    super.initState();
    _getBannerList();
    _getCategoryList();
    _getProductList();
    _getInVogueList();
    _getOneStopList();
  }

  void _getBannerList() async {
    _bannerList = await getBannerListAPI();
    setState(() {});
  }

  //分类列表
  void _getCategoryList() async {
    _categoryList = await getCategoryListAPI();
    setState(() {});
  }

  //特惠推荐
  void _getProductList() async {
    _specialRecommendResult = await getProductListAPI();
    setState(() {});
  }

  // 获取热榜推荐列表
  Future<void> _getInVogueList() async {
    _inVogueResult = await getInVogueListAPI();
  }

  // 获取一站式推荐列表
  Future<void> _getOneStopList() async {
    _oneStopResult = await getOneStopListAPI();
  }
  
 @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: _getScrollChildren()); //sliver家族内容
  }
}
