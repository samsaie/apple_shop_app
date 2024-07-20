import 'package:apple_shop_app/bloc/category_product/category_product_bloc.dart';
import 'package:apple_shop_app/bloc/category_product/category_product_event.dart';
import 'package:apple_shop_app/bloc/category_product/category_product_state.dart';
import 'package:apple_shop_app/constants/colors.dart';
import 'package:apple_shop_app/data/model/category.dart';
import 'package:apple_shop_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatefulWidget {
  final Category category;
  const ProductListScreen(this.category, {super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    BlocProvider.of<CategoryProductBloc>(context).add(
      CategoryProductInitialize(widget.category.id!),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryProductBloc, CategoryProductState>(
      builder: ((context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundScreenColor,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
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
                            child: Text(
                              widget.category.title!,
                              style: const TextStyle(
                                  fontFamily: 'sb',
                                  fontSize: 16,
                                  color: AppColors.blue),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state is CategoryProductResponseSuccessState) ...{
                  state.productListByCategory.fold((l) {
                    return SliverToBoxAdapter(
                      child: Text(l),
                    );
                  }, (productList) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 44),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(((context, index) {
                          return ProductItem(
                            productList[index],
                          );
                        }), childCount: productList.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 30,
                                childAspectRatio: 2 / 2.8),
                      ),
                    );
                  })
                }
              ],
            ),
          ),
        );
      }),
    );
  }
}
