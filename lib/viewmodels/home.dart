class BannerItem {
  String id;
  String imgUrl;
  BannerItem({required this.id, required this.imgUrl});
  //扩展一个工厂函数 一般用factory来声明，一般用来创建实例对象
  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json["id"] ?? "",
      imgUrl: json["imgUrl"] ?? "",
    );
  }
}

//Map<String,dynamic>
//每一个轮播图的具体类型
//flutter必须强制转化，没有隐式转化