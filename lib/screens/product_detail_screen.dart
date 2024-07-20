import 'dart:ui';

import 'package:apple_shop_app/bloc/basket/basket_bloc.dart';
import 'package:apple_shop_app/bloc/basket/basket_event.dart';
import 'package:apple_shop_app/bloc/comment/bloc/comment_bloc.dart';
import 'package:apple_shop_app/bloc/product/product_bloc.dart';
import 'package:apple_shop_app/bloc/product/product_event.dart';
import 'package:apple_shop_app/bloc/product/product_state.dart';
import 'package:apple_shop_app/constants/colors.dart';
import 'package:apple_shop_app/data/model/gallery.dart';
import 'package:apple_shop_app/data/model/product.dart';
import 'package:apple_shop_app/data/model/product_property.dart';
import 'package:apple_shop_app/data/model/product_variant.dart';
import 'package:apple_shop_app/data/model/valiant_type.dart';
import 'package:apple_shop_app/data/model/variant.dart';
import 'package:apple_shop_app/di/di.dart';
import 'package:apple_shop_app/widgets/cached_image.dart';
import 'package:apple_shop_app/widgets/loading_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apple_shop_app/util/extensions/double_extensions.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen(this.product, {super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) {
        var bloc = ProductBloc();
        bloc.add(
          ProductInitializeEvent(widget.product.id, widget.product.categoryId),
        );
        return bloc;
      }),
      child: DetailScreenContent(parentWidget: widget),
    );
  }
}

class DetailScreenContent extends StatelessWidget {
  const DetailScreenContent({
    super.key,
    required this.parentWidget,
  });

  final ProductDetailScreen parentWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreenColor,
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductDetailLoadingState) {
            return const Center(
              child: LoadingAnimation(),
            );
          }

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
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
                            Image.asset('assets/images/icon_apple_blue.png'),
                            Expanded(
                                child: state.productCategory.fold((l) {
                              return const Text(
                                'اطلاعات محصول',
                                style: TextStyle(
                                    fontFamily: 'sb',
                                    fontSize: 16,
                                    color: AppColors.blue),
                                textAlign: TextAlign.center,
                              );
                            }, (productCategory) {
                              return Text(
                                productCategory.title!,
                                style: const TextStyle(
                                    fontFamily: 'sb',
                                    fontSize: 16,
                                    color: AppColors.blue),
                                textAlign: TextAlign.center,
                              );
                            })),
                            Image.asset('assets/images/icon_back.png'),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                },
                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          parentWidget.product.name,
                          style: const TextStyle(
                            fontFamily: 'sb',
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                },
                if (state is ProductDetailResponseState) ...{
                  state.productImages.fold(
                    (l) {
                      return SliverToBoxAdapter(
                        child: Text(l),
                      );
                    },
                    (productImageList) {
                      return GalleryWidget(
                          productImageList, parentWidget.product.thumbnail);
                    },
                  )
                },
                if (state is ProductDetailResponseState) ...{
                  state.productVariant.fold(
                    (l) {
                      return SliverToBoxAdapter(
                        child: Text(l),
                      );
                    },
                    (productVariantList) {
                      return VariantContainerGenerator(productVariantList);
                    },
                  )
                },
                if (state is ProductDetailResponseState) ...{
                  state.productProperties.fold((l) {
                    return SliverToBoxAdapter(
                      child: Text(l),
                    );
                  }, (propertyList) {
                    return ProductProperties(propertyList);
                  })
                },
                if (state is ProductDetailResponseState) ...{
                  ProductDescription(parentWidget.product.description),
                },
                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: true,
                            showDragHandle: true,
                            useSafeArea: true,
                            context: context,
                            builder: (context) {
                              return BlocProvider(
                                create: (context) {
                                  final bloc = CommentBloc(locator.get());
                                  bloc.add(CommentInitializeEvent(
                                      parentWidget.product.id));
                                  return bloc;
                                },
                                child: CommentBottomSheet(
                                  productId: parentWidget.product.id,
                                ),
                              );
                            });
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 44, right: 44, top: 24),
                        height: 46,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1, color: AppColors.grey),
                            color: Colors.white),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset('assets/images/icon_left_categroy.png'),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'مشاهده ',
                              style: TextStyle(
                                  fontFamily: 'sb',
                                  fontSize: 12,
                                  color: AppColors.blue),
                            ),
                            const Spacer(),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  height: 26,
                                  width: 26,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      color: Colors.red),
                                ),
                                Positioned(
                                  right: 16,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    height: 26,
                                    width: 26,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Colors.green),
                                  ),
                                ),
                                Positioned(
                                  right: 32,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    height: 26,
                                    width: 26,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Colors.yellow),
                                  ),
                                ),
                                Positioned(
                                  right: 48,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    height: 26,
                                    width: 26,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Colors.blue),
                                  ),
                                ),
                                Positioned(
                                  right: 64,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    height: 26,
                                    width: 26,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Colors.grey),
                                    child: const Center(
                                      child: Text(
                                        '+10',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              ':نظرات کاربران ',
                              style: TextStyle(
                                fontFamily: 'sm',
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                },
                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 44, right: 44, top: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PriceBottom(parentWidget.product),
                            AddToBasketBottom(parentWidget.product),
                          ]),
                    ),
                  ),
                }
              ],
            ),
          );
        },
      ),
    );
  }
}

class CommentBottomSheet extends StatelessWidget {
  final String productId;
  final TextEditingController textController = TextEditingController();

  CommentBottomSheet({
    required this.productId,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentLoading) {
          const Center(
            child: LoadingAnimation(),
          );
        }
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  if (state is CommentResponse) ...{
                    state.response.fold((l) {
                      return const SliverToBoxAdapter(
                        child: Text('خطا در نمایش نظرات'),
                      );
                    }, (commentList) {
                      if (commentList.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Center(
                            child: Text('نظری ثبت نشده !!!'),
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue.shade100),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        (commentList[index].username.isEmpty)
                                            ? 'کاربر'
                                            : commentList[index].username,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.end,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        commentList[index].text,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: (commentList[index].avatar.isNotEmpty)
                                      ? CachedImage(
                                          imageUrl:
                                              commentList[index].userThumbnail,
                                        )
                                      : Image.asset('assets/images/avatar.png'),
                                ),
                              ],
                            ),
                          );
                        }, childCount: commentList.length),
                      );
                    })
                  },
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              fontFamily: 'sm',
                              fontSize: 18,
                              color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide:
                                BorderSide(color: Colors.black, width: 3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: AppColors.blue),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (textController.text.isEmpty) {
                                return;
                              }
                              context.read<CommentBloc>().add(CommentPostEvent(
                                  productId, textController.text));
                              textController.text = '';
                              // context.read<BasketBloc>().add(
                              //       BasketFetchFromHiveEvent(),
                              //     );
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppColors.blue),
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: const SizedBox(
                                height: 53,
                                child: Center(
                                  child: Text(
                                    'ثبت نظر',
                                    style: TextStyle(
                                      fontFamily: 'sb',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class ProductProperties extends StatefulWidget {
  final List<Property> productPropertyList;

  const ProductProperties(
    this.productPropertyList, {
    super.key,
  });

  @override
  State<ProductProperties> createState() => _ProductPropertiesState();
}

class _ProductPropertiesState extends State<ProductProperties> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(left: 44, right: 44, top: 24),
            height: 46,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: AppColors.grey),
                color: Colors.white),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset('assets/images/icon_left_categroy.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'مشاهده ',
                  style: TextStyle(
                      fontFamily: 'sb', fontSize: 12, color: AppColors.blue),
                ),
                const Spacer(),
                const Text(
                  ':مشخصات فنی',
                  style: TextStyle(
                    fontFamily: 'sm',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isVisible,
          child: Container(
              margin: const EdgeInsets.only(left: 44, right: 44, top: 24),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: AppColors.grey),
                  color: Colors.white),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.productPropertyList.length,
                  itemBuilder: (context, index) {
                    var property = widget.productPropertyList[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            '${property.value!} : ${property.title!}',
                            style: const TextStyle(
                                fontFamily: 'sm', fontSize: 14, height: 1.8),
                          ),
                        )
                      ],
                    );
                  })),
        ),
      ],
    ));
  }
}

class ProductDescription extends StatefulWidget {
  final String productDescription;
  const ProductDescription(
    this.productDescription, {
    super.key,
  });

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(left: 44, right: 44, top: 24),
            height: 46,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: AppColors.grey),
                color: Colors.white),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset('assets/images/icon_left_categroy.png'),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'مشاهده ',
                  style: TextStyle(
                      fontFamily: 'sb', fontSize: 12, color: AppColors.blue),
                ),
                const Spacer(),
                const Text(
                  ':توضیحات محصول ',
                  style: TextStyle(
                    fontFamily: 'sm',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isVisible,
          child: Container(
            margin: const EdgeInsets.only(left: 44, right: 44, top: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: AppColors.grey),
                color: Colors.white),
            child: Text(
              widget.productDescription,
              style:
                  const TextStyle(fontFamily: 'sm', fontSize: 14, height: 1.8),
              textAlign: TextAlign.right,
            ),
          ),
        )
      ],
    ));
  }
}

class VariantContainerGenerator extends StatelessWidget {
  final List<ProductVariant> productVariantList;

  const VariantContainerGenerator(
    this.productVariantList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          for (var productVariant in productVariantList) ...{
            if (productVariant.variantList.isNotEmpty) ...{
              VariantGeneratorChild(productVariant)
            }
          }
        ],
      ),
    );
  }
}

class VariantGeneratorChild extends StatelessWidget {
  final ProductVariant productVariant;
  const VariantGeneratorChild(this.productVariant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 44, right: 44, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            productVariant.variantType.title!,
            style: const TextStyle(fontFamily: 'sm', fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          if (productVariant.variantType.type == VariantTypeEnum.COLOR) ...{
            ColorVariantList(productVariant.variantList)
          },
          if (productVariant.variantType.type == VariantTypeEnum.STORAGE) ...{
            StorageVariantList(productVariant.variantList)
          },
        ],
      ),
    );
  }
}

class GalleryWidget extends StatefulWidget {
  final List<ProductImage> productImageList;
  final String defaultProductThumbnail;
  int selectedItem = 0;

  GalleryWidget(
    this.productImageList,
    this.defaultProductThumbnail, {
    super.key,
  });

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: Container(
          height: 284,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/icon_star.png'),
                          const SizedBox(
                            width: 2,
                          ),
                          const Text(
                            '۴.۶',
                            style: TextStyle(fontFamily: 'sm', fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 200,
                        child: CachedImage(
                            imageUrl: (widget.productImageList.isEmpty)
                                ? widget.defaultProductThumbnail
                                : widget.productImageList[widget.selectedItem]
                                    .imageUrl),
                      ),
                      const Spacer(),
                      Image.asset('assets/images/icon_favorite_deactive.png')
                    ],
                  ),
                ),
              ),
              if (widget.productImageList.isNotEmpty) ...{
                SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44, right: 44, top: 4),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productImageList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                widget.selectedItem = index;
                              },
                            );
                          },
                          child: Container(
                            height: 70,
                            width: 70,
                            margin: const EdgeInsets.only(left: 20),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border:
                                  Border.all(width: 1, color: AppColors.grey),
                            ),
                            child: CachedImage(
                              imageUrl: widget.productImageList[index].imageUrl,
                              radius: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              }
            ],
          ),
        ),
      ),
    );
  }
}

class AddToBasketBottom extends StatelessWidget {
  final Product product;
  const AddToBasketBottom(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        GestureDetector(
          onTap: () {
            context.read<ProductBloc>().add(ProductAddToBasket(product));
            context.read<BasketBloc>().add(BasketFetchFromHiveEvent());
          },
          child: Container(
            height: 60,
            width: 140,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: AppColors.blue),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const SizedBox(
              height: 53,
              width: 160,
              child: Center(
                child: Text(
                  ' افزودن به سبد خرید',
                  style: TextStyle(
                    fontFamily: 'sb',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PriceBottom extends StatelessWidget {
  final Product product;
  const PriceBottom(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          height: 60,
          width: 140,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: AppColors.green),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SizedBox(
              height: 53,
              width: 160,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        'تومان',
                        style: TextStyle(
                            fontFamily: 'SM',
                            color: Colors.white,
                            fontSize: 12),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.realPrice.convertToPrice(),
                            style: const TextStyle(
                                fontFamily: 'SM',
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough),
                          ),
                          Text(
                            product.price.convertToPrice(),
                            style: const TextStyle(
                                fontFamily: 'SM',
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                          child: Text(
                            '٪۳',
                            style: TextStyle(
                                fontFamily: 'SM',
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ColorVariantList extends StatefulWidget {
  final List<Variant> variantList;

  const ColorVariantList(this.variantList, {super.key});

  @override
  State<ColorVariantList> createState() => _ColorVariantListState();
}

class _ColorVariantListState extends State<ColorVariantList> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.variantList.length,
          itemBuilder: (context, index) {
            String categoryColor = 'ff${widget.variantList[index].value}';
            int hexColor = int.parse(categoryColor, radix: 16);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  border: (_selectedIndex == index)
                      ? Border.all(
                          width: 1,
                          color: AppColors.blueIndicator,
                          strokeAlign: BorderSide.strokeAlignOutside)
                      : Border.all(width: 2, color: Colors.white),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(hexColor),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StorageVariantList extends StatefulWidget {
  final List<Variant> storageVariants;

  const StorageVariantList(this.storageVariants, {super.key});

  @override
  State<StorageVariantList> createState() => _StorageVariantListState();
}

class _StorageVariantListState extends State<StorageVariantList> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 26,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.storageVariants.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 25,
                  decoration: BoxDecoration(
                    border: (_selectedIndex == index)
                        ? Border.all(
                            width: 2,
                            color: AppColors.blueIndicator,
                            strokeAlign: BorderSide.strokeAlignOutside)
                        : Border.all(width: 1, color: AppColors.grey),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        widget.storageVariants[index].value!,
                        style: const TextStyle(fontFamily: 'sb', fontSize: 12),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
