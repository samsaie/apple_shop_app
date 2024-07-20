import 'package:apple_shop_app/bloc/basket/basket_bloc.dart';
import 'package:apple_shop_app/bloc/basket/basket_event.dart';
import 'package:apple_shop_app/bloc/basket/basket_state.dart';
import 'package:apple_shop_app/constants/colors.dart';
import 'package:apple_shop_app/data/model/card_item.dart';
import 'package:apple_shop_app/util/extensions/double_extensions.dart';
import 'package:apple_shop_app/util/extensions/string_extensions.dart';
import 'package:apple_shop_app/widgets/cached_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box<BasketItem>('CardBox');

    return Scaffold(
      backgroundColor: AppColors.backgroundScreenColor,
      body: SafeArea(
        child: BlocBuilder<BasketBloc, BasketState>(
          builder: (context, state) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomScrollView(
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
                                  'سبد خرید',
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
                    if (state is BasketDataFetchedState) ...{
                      state.basketItemList.fold(
                        ((l) {
                          return SliverToBoxAdapter(
                            child: Text(l),
                          );
                        }),
                        ((basketItemList) {
                          return SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return CardItem(basketItemList[index], index);
                            }, childCount: basketItemList.length),
                          );
                        }),
                      ),
                    },
                    const SliverPadding(padding: EdgeInsets.only(bottom: 100))
                  ],
                ),
                if (state is BasketDataFetchedState) ...{
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 44, right: 44, bottom: 20),
                    child: SizedBox(
                      height: 52,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          context
                              .read<BasketBloc>()
                              .add(BasketPaymentInitEvent());

                          context
                              .read<BasketBloc>()
                              .add(BasketPaymentRequestEvent());
                        },
                        child: Text(
                          (state.basketFinalPrice == 0)
                              ? 'سبد خرید خالی می باشد'
                              : 'مبلغ پرداخت :  ${state.basketFinalPrice.convertToPrice()} ',
                          style: const TextStyle(
                              fontFamily: 'sm',
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                }
              ],
            );
          },
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final BasketItem basketItem;
  final int index;

  const CardItem(
    this.basketItem,
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.only(left: 44, right: 44, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  height: 104,
                  child: CachedImage(
                    imageUrl: basketItem.thumbnail,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        basketItem.name,
                        style: const TextStyle(fontFamily: 'sb', fontSize: 16),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Text(
                        'گارانتی ۱۸ ماه مدیا پردازش',
                        style: TextStyle(
                            fontFamily: 'sm',
                            fontSize: 12,
                            color: AppColors.grey),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${basketItem.price.convertToPrice()}',
                            style: const TextStyle(
                                fontFamily: 'sb',
                                fontSize: 10,
                                color: AppColors.grey),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Text('تومان',
                              style: TextStyle(
                                  fontFamily: 'sm',
                                  fontSize: 12,
                                  color: AppColors.grey)),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 6),
                              child: Text(
                                '٪۳',
                                style: TextStyle(
                                    fontFamily: 'SM',
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Wrap(
                        spacing: 5,
                        runSpacing: 2,
                        children: [
                          // OptionCheap(
                          //   '۲۵۶ گیگابایت',
                          // ),
                          const OptionCheap(
                            'آبی',
                            color: '1180f3',
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<BasketBloc>()
                                  .add(BasketRemoveProductEvent(index));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border:
                                    Border.all(width: 1, color: AppColors.red),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 12,
                                      child: Image.asset(
                                        'assets/images/icon_trash.png',
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Text(
                                      'حذف',
                                      style: TextStyle(
                                          fontFamily: 'SM',
                                          fontSize: 12,
                                          color: AppColors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DottedLine(
              lineThickness: 1.5,
              dashColor: AppColors.grey,
              dashGapColor: Colors.transparent,
              dashLength: 8,
              dashGapLength: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${basketItem.price.convertToPrice()}',
                  style: const TextStyle(
                    fontFamily: 'sb',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'تومان',
                  style: TextStyle(
                    fontFamily: 'sb',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OptionCheap extends StatelessWidget {
  final String? color;
  final String title;

  const OptionCheap(
    this.title, {
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(width: 1, color: AppColors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...{
              Container(
                margin: const EdgeInsets.only(left: 4),
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color!.parseToColor(),
                ),
              )
            },
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'SM',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
