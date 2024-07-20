class BannerCampaign {
  String? collectionId;
  String? id;
  String? thumbnail;
  String? categoryId;

  BannerCampaign(
    this.collectionId,
    this.id,
    this.thumbnail,
    this.categoryId,
  );

  factory BannerCampaign.fromMapJson(Map<String, dynamic> jsonObject) {
    return BannerCampaign(
      jsonObject['collectionId'],
      jsonObject['id'],
      'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
      jsonObject['categoryId'],
    );
  }
}
