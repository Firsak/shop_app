import 'package:flutter/material.dart';

import '../providers/product.dart';
import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyShop',
          // style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      body: ProductsGrid(),
    );
  }
}
