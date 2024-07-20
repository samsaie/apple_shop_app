import 'package:apple_shop_app/bloc/category/category_bloc.dart';
import 'package:apple_shop_app/bloc/category/category_event.dart';
import 'package:apple_shop_app/bloc/category/category_state.dart';
import 'package:apple_shop_app/constants/colors.dart';
import 'package:apple_shop_app/data/model/category.dart';
import 'package:apple_shop_app/widgets/cached_image.dart';
import 'package:apple_shop_app/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    BlocProvider.of<CategoryBloc>(context).add(CategoryRequestList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      const Expanded(
                        child: Text(
                          'دسته بندی',
                          style: TextStyle(
                              fontFamily: 'sb',
                              fontSize: 16,
                              color: AppColors.blue),
                          textAlign: TextAlign.center,
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
            ),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: ((context, state) {
                if (state is CategoryLoadingState) {
                  return const SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [LoadingAnimation()],
                    ),
                  );
                }
                if (state is CategoryResponseState) {
                  return state.response.fold((l) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(l)),
                    );
                  }, (r) {
                    return ListCategory(list: r);
                  });
                }
                return const SliverToBoxAdapter(
                  child: Text('erroooor'),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ListCategory extends StatelessWidget {
  final List<Category>? list;

  const ListCategory({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(((context, index) {
          return GestureDetector(
              child: CachedImage(imageUrl: list?[index].thumbnail));
        }), childCount: list?.length ?? 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
      ),
    );
  }
}
