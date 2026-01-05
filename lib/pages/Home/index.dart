import 'package:flutter/material.dart';
import 'package:hm_shop/api/home.dart';
import 'package:hm_shop/components/Home/HmCategory.dart';
import 'package:hm_shop/components/Home/HmHot.dart';
import 'package:hm_shop/components/Home/HmMoreList.dart';
import 'package:hm_shop/components/Home/HmSlider.dart';
import 'package:hm_shop/components/Home/HmSuggestion.dart';
import 'package:hm_shop/utils/ToastUtils.dart';
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
      HmMoreList(recommendList: _recommendList),
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

  List<GoodDetailItem> _recommendList = [];

  @override
  void initState() {
    super.initState();
    _registerEvent();
    Future.microtask(() {
      _paddingTop = 100;
      setState(() {});
      _key.currentState?.show();
    });
  }
  // initState > build => 下拉刷新组件 => 才可以操作它
  // Future.micoTask

  void _registerEvent() {
    //监听滚动到底部的事件
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        // 滚动到底部
        print("滚动到底部");
        _getRecommendList();
      }
    });
  }

  Future<void> _getBannerList() async {
    _bannerList = await getBannerListAPI();
    setState(() {});
  }

  //分类列表
  Future<void> _getCategoryList() async {
    _categoryList = await getCategoryListAPI();
    setState(() {});
  }

  //特惠推荐
  Future<void> _getProductList() async {
    _specialRecommendResult = await getProductListAPI();
    setState(() {});
  }

  //页码
  int _page = 1;
  bool _isLoading = false; //当前正在加载的状态
  bool _hasMore = true; //是否还有下一页

  // 获取推荐列表
  Future<void> _getRecommendList() async {
    //当前已经有请求正在加载 或者已经没有下一页了 就放弃请求
    if (_isLoading || !_hasMore) {
      return;
    }
    _isLoading = true; //占住位置
    int requestLimit = _page * 10;
    _recommendList = await getRecommendListAPI({"limit": requestLimit});
    _isLoading = false; //松开位置
    setState(() {});
    //我要10条 你给10条 说明我要的都给了，说明还有下一页
    //我要10条 你给9条，说明我要的都给了，说明没有下一页了
    if (_recommendList.length < requestLimit) {
      _hasMore = false;
      return;
    }

    _page++;
  }

  // 获取热榜推荐列表
  Future<void> _getInVogueList() async {
    _inVogueResult = await getInVogueListAPI();
  }

  // 获取一站式推荐列表
  Future<void> _getOneStopList() async {
    _oneStopResult = await getOneStopListAPI();
  }

  Future<void> _onRefresh() async {
    _page = 1;
    _isLoading = false;
    _hasMore = true;
    await _getBannerList();
    await _getCategoryList();
    await _getProductList();
    await _getInVogueList();
    await _getOneStopList();
    await _getRecommendList();
    ToastUtils.showToast(context, "刷新成功");
    _paddingTop = 0;
    setState(() {});
  }

  final ScrollController _scrollController = ScrollController();

  //GlobalKey 是一个方法，可以创建一个Key绑定到Widget部件上 可以操作Wiget部件
  final GlobalKey<RefreshIndicatorState> _key =
      GlobalKey<RefreshIndicatorState>();
  double _paddingTop = 0;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _key,
      onRefresh: () async {
        await _onRefresh();
      },
      child: AnimatedContainer(
        padding: EdgeInsets.only(top: _paddingTop),
        duration: Duration(milliseconds: 300),
        child: CustomScrollView(
          controller: _scrollController, //绑定controller
          slivers: _getScrollChildren(),
        ),
      ),
    );
  }
}
