import 'package:apple_shop_app/bloc/home/home_bloc.dart';
import 'package:apple_shop_app/bloc/home/home_event.dart';
import 'package:apple_shop_app/bloc/home/home_state.dart';
import 'package:apple_shop_app/constants/colors.dart';
import 'package:apple_shop_app/data/model/banner.dart';
import 'package:apple_shop_app/data/model/category.dart';
import 'package:apple_shop_app/data/model/product.dart';
import 'package:apple_shop_app/widgets/banner_slider.dart';
import 'package:apple_shop_app/widgets/category_icon_item_chip.dart';
import 'package:apple_shop_app/widgets/loading_animation.dart';
import 'package:apple_shop_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreenColor,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          return _getHomeScreenContent(state, context);
        }),
      ),
    );
  }
}

Widget _getHomeScreenContent(HomeState state, context) {
  if (state is HomeLoadingState) {
    return const Center(
      child: LoadingAnimation(),
    );
  } else if (state is HomeRequestSuccessState) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeGetInitializeData());
      },
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.only(top: 24),
          ),
          const _GetSearchBox(),
          state.bannerList.fold(
            (exceptionMessage) {
              return SliverToBoxAdapter(child: Text(exceptionMessage));
            },
            (listBanners) {
              return _GetBannerCampaigns(listBanners);
            },
          ),
          const _GetCategoryListTitle(),
          state.categoryList.fold(
            (exceptionMessage) {
              return SliverToBoxAdapter(child: Text(exceptionMessage));
            },
            (categoryList) {
              return _GetCategoryList(categoryList);
            },
          ),
          const _GetBestSellerTitle(),
          state.bestSellerProductList.fold(
            (exceptionMessage) {
              return SliverToBoxAdapter(child: Text(exceptionMessage));
            },
            (productList) {
              return _GetBestSellerProducts(productList);
            },
          ),
          const _GetMostViewedTitle(),
          state.hottestProductList.fold(
            (exceptionMessage) {
              return SliverToBoxAdapter(child: Text(exceptionMessage));
            },
            (productList) {
              return _GetMostViewedProducts(productList);
            },
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 24),
          ),
        ],
      ),
    );
  } else {
    return const Center(
      child: Text('errrooooooorrrrr'),
    );
  }
}

class _GetMostViewedProducts extends StatelessWidget {
  final List<Product> productList;
  const _GetMostViewedProducts(
    this.productList,
  );

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 44),
        child: SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ProductItem(productList[index]),
                );
              })),
        ),
      ),
    );
  }
}

class _GetMostViewedTitle extends StatelessWidget {
  const _GetMostViewedTitle();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 44, right: 44, bottom: 20, top: 32),
        child: Row(
          children: [
            const Text(
              'پربازدید ترین ها',
              style: TextStyle(
                fontFamily: 'sb',
                color: AppColors.grey,
              ),
            ),
            const Spacer(),
            const Text(
              'مشاهده همه',
              style: TextStyle(fontFamily: 'sb', color: AppColors.blue),
            ),
            const SizedBox(
              width: 10,
            ),
            Image.asset('assets/images/icon_left_categroy.png'),
          ],
        ),
      ),
    );
  }
}

class _GetBestSellerProducts extends StatelessWidget {
  final List<Product> productList;
  const _GetBestSellerProducts(this.productList);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 44),
        child: SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ProductItem(productList[index]),
                );
              })),
        ),
      ),
    );
  }
}

class _GetBestSellerTitle extends StatelessWidget {
  const _GetBestSellerTitle();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 44, right: 44, bottom: 20),
        child: Row(
          children: [
            const Text(
              'پرفروش ترین ها',
              style: TextStyle(
                fontFamily: 'sb',
                color: AppColors.grey,
              ),
            ),
            const Spacer(),
            const Text(
              'مشاهده همه',
              style: TextStyle(fontFamily: 'sb', color: AppColors.blue),
            ),
            const SizedBox(
              width: 10,
            ),
            Image.asset('assets/images/icon_left_categroy.png'),
          ],
        ),
      ),
    );
  }
}

class _GetCategoryList extends StatelessWidget {
  final List<Category> listCategories;
  const _GetCategoryList(this.listCategories);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 44),
        child: SizedBox(
          height: 100,
          child: ListView.builder(
              itemCount: listCategories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CategoryItemChip(listCategories[index]),
                );
              })),
        ),
      ),
    );
  }
}

class _GetCategoryListTitle extends StatelessWidget {
  const _GetCategoryListTitle();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 44, right: 44, bottom: 20, top: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'دسته بندی',
              style: TextStyle(
                fontFamily: 'sb',
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GetBannerCampaigns extends StatelessWidget {
  final List<BannerCampaign> bannerCampaign;
  const _GetBannerCampaigns(this.bannerCampaign);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BannerSlider(bannerCampaign),
    );
  }
}

class _GetSearchBox extends StatelessWidget {
  const _GetSearchBox();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 44,
          right: 44,
          bottom: 32,
        ),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Image.asset('assets/images/icon_search.png'),
              const SizedBox(
                width: 10,
              ),
              const Expanded(
                child: Text(
                  'جستجوی محصول',
                  style: TextStyle(
                      fontFamily: 'sb', fontSize: 16, color: AppColors.grey),
                  textAlign: TextAlign.start,
                ),
              ),
              Image.asset('assets/images/icon_apple_blue.png'),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
