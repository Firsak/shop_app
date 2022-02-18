import 'package:flutter/material.dart';

import './screens/producs_overview_screen.dart';
import './screens/product_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeData theme = ThemeData(
    primarySwatch: Colors.purple,
    fontFamily: 'Lato',
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: theme.copyWith(
        colorScheme: theme.copyWith().colorScheme.copyWith(
              secondary: Colors.deepOrange,
            ),
      ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
      },
    );
  }
}
