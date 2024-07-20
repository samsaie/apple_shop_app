import 'package:apple_shop_app/data/model/category.dart';
import 'package:apple_shop_app/di/di.dart';
import 'package:apple_shop_app/util/api_exception.dart';
import 'package:dio/dio.dart';

abstract class ICategoryDataSource {
  Future<List<Category>> getCategories();
}

class CategoryRemoteDataSource extends ICategoryDataSource {
  final Dio _dio = locator.get();

  @override
  Future<List<Category>> getCategories() async {
    try {
      var respones = await _dio.get('collections/category/records');
      return respones.data['items']
          .map<Category>((jsonObject) => Category.fromMapJson(jsonObject))
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
