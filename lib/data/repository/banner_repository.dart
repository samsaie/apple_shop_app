import 'package:apple_shop_app/data/datasource/banner_datasource.dart';
import 'package:apple_shop_app/data/model/banner.dart';
import 'package:apple_shop_app/di/di.dart';
import 'package:apple_shop_app/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IBannerRepository {
  Future<Either<String, List<BannerCampaign>>> getBanners();
}

class BannerRepository extends IBannerRepository {
  final IBannerDataSource _datasource = locator.get();

  @override
  Future<Either<String, List<BannerCampaign>>> getBanners() async {
    try {
      var response = await _datasource.getBanners();
      return right(response);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
