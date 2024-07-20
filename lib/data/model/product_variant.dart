import 'package:apple_shop_app/data/model/valiant_type.dart';
import 'package:apple_shop_app/data/model/variant.dart';

class ProductVariant {
  VariantType variantType;
  List<Variant> variantList;

  ProductVariant(this.variantType, this.variantList);
}
