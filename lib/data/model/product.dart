class Product {
  String categoryId;
  String collectionId;
  String description;
  int discountPrice;
  String id;
  String name;
  String popularity;
  int price;
  int quantity;
  String thumbnail;
  int? realPrice;
  num? persent;

  Product(
      this.categoryId,
      this.collectionId,
      this.description,
      this.discountPrice,
      this.id,
      this.name,
      this.popularity,
      this.price,
      this.quantity,
      this.thumbnail) {
    realPrice = price + discountPrice;
    persent = ((price - discountPrice) / price);
  }

  factory Product.fromMapJson(Map<String, dynamic> jsonObject) {
    return Product(
      jsonObject['category'],
      jsonObject['collectionId'],
      jsonObject['description'],
      jsonObject['discount_price'],
      jsonObject['id'],
      jsonObject['name'],
      jsonObject['popularity'],
      jsonObject['price'],
      jsonObject['quantity'],
      'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
    );
  }
}
