import 'package:apple_shop_app/bloc/authentication/auth_bloc.dart';
import 'package:apple_shop_app/bloc/authentication/auth_event.dart';
import 'package:apple_shop_app/bloc/authentication/auth_state.dart';
import 'package:apple_shop_app/constants/colors.dart';
import 'package:apple_shop_app/screens/dashboard_screen.dart';
import 'package:apple_shop_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _usernameTextController = TextEditingController(text: 'samsaie33');
  final _passwordTextController = TextEditingController(text: '12345678');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: ViewContainer(
          usernameTextController: _usernameTextController,
          passwordTextController: _passwordTextController),
    );
  }
}

class ViewContainer extends StatelessWidget {
  const ViewContainer({
    super.key,
    required TextEditingController usernameTextController,
    required TextEditingController passwordTextController,
  })  : _usernameTextController = usernameTextController,
        _passwordTextController = passwordTextController;

  final TextEditingController _usernameTextController;
  final TextEditingController _passwordTextController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                      height: 200,
                      child: Image.asset('assets/images/login_photo.jpg')),
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'نام کاربری :',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'dana',
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: TextField(
                            controller: _usernameTextController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                  fontFamily: 'sm',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'رمز عبور:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'dana',
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: TextField(
                            controller: _passwordTextController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                  fontFamily: 'sm',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthResponseState) {
                        state.response.fold((l) {
                          _usernameTextController.text = '';
                          _passwordTextController.text = '';
                          var snackBar = SnackBar(
                            backgroundColor: Colors.blue[700],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            duration: const Duration(seconds: 1),
                            content: Text(
                              l,
                              style: const TextStyle(
                                  fontFamily: 'dana',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }, (r) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(),
                            ),
                          );
                        });
                      }
                    },
                    builder: ((context, state) {
                      if (state is AuthInitiateState) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle:
                                const TextStyle(fontFamily: 'sb', fontSize: 20),
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(200, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(
                              AuthLoginRequest(_usernameTextController.text,
                                  _passwordTextController.text),
                            );
                          },
                          child: const Text('ورود به حساب کاربری'),
                        );
                      }
                      if (state is AuthLoadingState) {
                        return const CircularProgressIndicator();
                      }
                      if (state is AuthResponseState) {
                        Widget widget = const Text('');
                        state.response.fold((l) {
                          widget = ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                  fontFamily: 'sb', fontSize: 20),
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(200, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context).add(
                                AuthLoginRequest(_usernameTextController.text,
                                    _passwordTextController.text),
                              );
                            },
                            child: const Text('ورود به حساب کاربری'),
                          );
                        }, (r) {
                          widget = Text(r);
                        });
                        return widget;
                      }
                      return const Text('خطای نامشخص');
                    }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'اگر حساب کاربری ندارید',
                        children: [
                          TextSpan(
                            text: ' ثبت نام ',
                            style: TextStyle(
                                color: AppColors.red, fontFamily: 'dana'),
                          ),
                          TextSpan(text: 'کنید')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
