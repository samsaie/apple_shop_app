import 'package:apple_shop_app/data/model/banner.dart';
import 'package:apple_shop_app/data/model/category.dart';
import 'package:apple_shop_app/data/model/product.dart';
import 'package:dartz/dartz.dart';

abstract class HomeState {}

class HomeInitState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeRequestSuccessState extends HomeState {
  Either<String, List<BannerCampaign>> bannerList;
  Either<String, List<Category>> categoryList;
  Either<String, List<Product>> productList;
  Either<String, List<Product>> hottestProductList;
  Either<String, List<Product>> bestSellerProductList;

  HomeRequestSuccessState(this.bannerList, this.categoryList, this.productList,
      this.bestSellerProductList, this.hottestProductList);
}
