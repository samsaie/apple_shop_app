import 'package:apple_shop_app/data/model/banner.dart';
import 'package:apple_shop_app/di/di.dart';
import 'package:apple_shop_app/util/api_exception.dart';
import 'package:dio/dio.dart';

abstract class IBannerDataSource {
  Future<List<BannerCampaign>> getBanners();
}

class BannerRemoteDataSource extends IBannerDataSource {
  final Dio _dio = locator.get();

  @override
  Future<List<BannerCampaign>> getBanners() async {
    try {
      var respones = await _dio.get('collections/banner/records');
      return respones.data['items']
          .map<BannerCampaign>(
              (jsonObject) => BannerCampaign.fromMapJson(jsonObject))
          .toList();
    } on DioError catch (ex) {
      throw ApiException(
        (ex.response?.statusCode),
        (ex.response?.data['message']),
      );
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }
}
