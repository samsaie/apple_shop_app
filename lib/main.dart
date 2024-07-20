import 'package:apple_shop_app/data/model/card_item.dart';
import 'package:apple_shop_app/di/di.dart';
import 'package:apple_shop_app/screens/dashboard_screen.dart';
import 'package:apple_shop_app/screens/login_screen.dart';
import 'package:apple_shop_app/util/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(
    BasketItemAdapter(),
  );
  await Hive.openBox<BasketItem>('CardBox');

  await getItInit();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedBottomNavigationIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: (AuthManager.readAuth().isEmpty)
            ? LoginScreen()
            : const DashboardScreen(),
      ),
    );
  }
}
