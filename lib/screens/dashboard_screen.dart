import 'dart:ui';
import 'package:apple_shop_app/bloc/basket/basket_bloc.dart';
import 'package:apple_shop_app/bloc/basket/basket_event.dart';
import 'package:apple_shop_app/bloc/category/category_bloc.dart';
import 'package:apple_shop_app/bloc/home/home_bloc.dart';
import 'package:apple_shop_app/bloc/home/home_event.dart';
import 'package:apple_shop_app/constants/colors.dart';
import 'package:apple_shop_app/di/di.dart';
import 'package:apple_shop_app/screens/card_screen.dart';
import 'package:apple_shop_app/screens/category_screen.dart';
import 'package:apple_shop_app/screens/home_screen.dart';
import 'package:apple_shop_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedBottomNavigationIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: IndexedStack(
            index: selectedBottomNavigationIndex,
            children: getScreen(),
          ),
          bottomNavigationBar: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: BottomNavigationBar(
                onTap: (int index) {
                  setState(() {
                    selectedBottomNavigationIndex = index;
                  });
                },
                currentIndex: selectedBottomNavigationIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: AppColors.blue,
                unselectedItemColor: Colors.black,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                selectedLabelStyle: const TextStyle(
                  fontFamily: 'sb',
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'sb',
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/images/icon_home.png'),
                    activeIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 20,
                              spreadRadius: -7,
                              offset: Offset(0.0, 13),
                            ),
                          ],
                        ),
                        child:
                            Image.asset('assets/images/icon_home_active.png'),
                      ),
                    ),
                    label: 'خانه',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/images/icon_category.png'),
                    activeIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 20,
                              spreadRadius: -7,
                              offset: Offset(0.0, 13),
                            ),
                          ],
                        ),
                        child: Image.asset(
                            'assets/images/icon_category_active.png'),
                      ),
                    ),
                    label: 'دسته بندی',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/images/icon_basket.png'),
                    activeIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 20,
                              spreadRadius: -7,
                              offset: Offset(0.0, 13),
                            ),
                          ],
                        ),
                        child:
                            Image.asset('assets/images/icon_basket_active.png'),
                      ),
                    ),
                    label: 'سبد خرید',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/images/icon_profile.png'),
                    activeIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 20,
                              spreadRadius: -7,
                              offset: Offset(0.0, 13),
                            ),
                          ],
                        ),
                        child: Image.asset(
                            'assets/images/icon_profile_active.png'),
                      ),
                    ),
                    label: 'حساب کاربری',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> getScreen() {
  return <Widget>[
    BlocProvider(
        create: (context) {
          var bloc = HomeBloc();
          bloc.add(HomeGetInitializeData());
          return bloc;
        },
        child: const HomeScreen()),
    BlocProvider(
      create: (context) => CategoryBloc(),
      child: const CategoryScreen(),
    ),
    BlocProvider(
      create: ((context) {
        var bloc = locator.get<BasketBloc>();
        bloc.add(BasketFetchFromHiveEvent());
        return bloc;
      }),
      child: const CardScreen(),
    ),
    const ProfileScreen(),
  ];
}
