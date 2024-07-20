import 'package:hive/hive.dart';

part 'card_item.g.dart';

@HiveType(typeId: 0)
class BasketItem {
  @HiveField(0)
  String categoryId;
  @HiveField(1)
  String collectionId;
  @HiveField(2)
  int discountPrice;
  @HiveField(3)
  String id;
  @HiveField(4)
  String name;
  @HiveField(5)
  int price;
  @HiveField(6)
  String thumbnail;
  @HiveField(7)
  int? realPrice;
  @HiveField(8)
  num? persent;

  BasketItem(this.categoryId, this.collectionId, this.discountPrice, this.id,
      this.name, this.price, this.thumbnail) {
    realPrice = price + discountPrice;
    persent = ((price - discountPrice) / price) * 100;
  }
  //this.thumbnail= 'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
}
