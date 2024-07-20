import 'package:apple_shop_app/bloc/category_product/category_product_bloc.dart';
import 'package:apple_shop_app/data/model/category.dart';
import 'package:apple_shop_app/screens/products_list_screen.dart';
import 'package:apple_shop_app/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryItemChip extends StatelessWidget {
  final Category category;

  const CategoryItemChip(
    this.category, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String categoryColor = 'ff${category.color}';
    int hexColor = int.parse(categoryColor, radix: 16);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => CategoryProductBloc(),
              child: ProductListScreen(category),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: ShapeDecoration(
                  color: Color(hexColor),
                  shadows: [
                    BoxShadow(
                      color: Color(hexColor),
                      blurRadius: 25,
                      spreadRadius: -9,
                      offset: const Offset(0.0, 10),
                    ),
                  ],
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
                width: 24,
                child: Center(
                  child: CachedImage(
                    imageUrl: category.icon,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            category.title ?? 'محصول',
            style: const TextStyle(fontFamily: 'SB', fontSize: 12),
          )
        ],
      ),
    );
  }
}
