import 'package:flutter/material.dart';
import 'features/menu/view/menu_screen.dart';
import 'theme/theme.dart';

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: coffeeAppTheme,
        home: Container(
          color: coffeeAppTheme.colorScheme.background,
          child: const SafeArea(child: MenuScreen()),
        ));
  }
}
