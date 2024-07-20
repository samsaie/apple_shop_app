import 'package:apple_shop_app/data/datasource/category_product_datasource.dart';
import 'package:apple_shop_app/data/model/product.dart';
import 'package:apple_shop_app/di/di.dart';
import 'package:apple_shop_app/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class ICategoryProductRepository {
  Future<Either<String, List<Product>>> getProductByCategoryId(
      String categoryId);
}

class CategoryProductRepository extends ICategoryProductRepository {
  final ICategoryProductDataSource _datasource = locator.get();

  @override
  Future<Either<String, List<Product>>> getProductByCategoryId(
      String categoryId) async {
    try {
      var response = await _datasource.getProductByCategoryId(categoryId);
      return right(response);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
