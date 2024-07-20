import 'package:apple_shop_app/bloc/product/product_event.dart';
import 'package:apple_shop_app/bloc/product/product_state.dart';
import 'package:apple_shop_app/data/model/card_item.dart';
import 'package:apple_shop_app/data/repository/basket_repository.dart';
import 'package:apple_shop_app/data/repository/product_detail_repository.dart';
import 'package:apple_shop_app/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IDetailProductRepository _productRepository = locator.get();
  final IBasketRepository _basketRepository = locator.get();

  ProductBloc() : super(ProductInitState()) {
    on<ProductInitializeEvent>(
      (event, emit) async {
        emit(ProductDetailLoadingState());
        var productImages =
            await _productRepository.getProductImage(event.productId);
        var productVariant =
            await _productRepository.getProductVariants(event.productId);
        var productCategory =
            await _productRepository.getProductCategory(event.categoryId);
        var productProperties =
            await _productRepository.getProductProperties(event.productId);

        emit(ProductDetailResponseState(
            productImages, productVariant, productCategory, productProperties));
      },
    );

    on<ProductAddToBasket>(((event, emit) {
      var basketItem = BasketItem(
          event.product.categoryId,
          event.product.collectionId,
          event.product.discountPrice,
          event.product.id,
          event.product.name,
          event.product.price,
          event.product.thumbnail);

      _basketRepository.addProductToBasket(basketItem);
    }));
  }
}
