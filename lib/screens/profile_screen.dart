import 'package:apple_shop_app/bloc/authentication/auth_bloc.dart';
import 'package:apple_shop_app/bloc/authentication/auth_state.dart';
import 'package:apple_shop_app/constants/colors.dart';
import 'package:apple_shop_app/screens/login_screen.dart';
import 'package:apple_shop_app/util/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreenColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
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
                        'حساب کاربری',
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
            const Text(
              'ثمر ساعی',
              style: TextStyle(fontFamily: 'sb', fontSize: 16),
            ),
            const Text(
              '۰۹۱۲۳۰۶۲۰۵۴',
              style: TextStyle(fontFamily: 'sm', fontSize: 10),
            ),
            const SizedBox(
              height: 10,
            ),
            // BlocBuilder<AuthBloc, AuthState>(builder: ((context, state) {
            //   if (state is AuthInitiateState) {
            //     return Text(
            //       'name',
            //       style: TextStyle(fontFamily: 'sb', fontSize: 16),
            //     );
            //   }
            //   return Text('data');
            // })),
            const Spacer(),
            GestureDetector(
              onTap: () {
                AuthManager.logout();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
              child: const Text(
                'خروج از حساب کاربری',
                style: TextStyle(fontFamily: 'dana', color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'اپل شاپ',
              style: TextStyle(
                  fontFamily: 'sm', fontSize: 10, color: AppColors.grey),
            ),
            const Text('v-1.0.00',
                style: TextStyle(
                    fontFamily: 'sm', fontSize: 10, color: AppColors.grey)),
            const Text('Instagram.com/Mojava-dev',
                style: TextStyle(
                    fontFamily: 'sm', fontSize: 10, color: AppColors.grey))
          ],
        ),
      ),
    );
  }
}
