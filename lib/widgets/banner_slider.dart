import 'package:apple_shop_app/constants/colors.dart';
import 'package:apple_shop_app/data/model/banner.dart';
import 'package:apple_shop_app/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  final List<BannerCampaign> bannerList;

  const BannerSlider(
    this.bannerList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = PageController(viewportFraction: 0.9);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 177,
          child: PageView.builder(
            itemCount: bannerList.length,
            controller: controller,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: CachedImage(
                  imageUrl: bannerList[index].thumbnail,
                  radius: 15,
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          child: SmoothPageIndicator(
            controller: controller,
            count: 4,
            effect: const ExpandingDotsEffect(
              expansionFactor: 5,
              dotColor: Colors.white,
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: AppColors.blueIndicator,
            ),
          ),
        ),
      ],
    );
  }
}
