import 'package:flutter/material.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(this.id, this.title, this.imageUrl, {Key? key})
      : super(key: key);

  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: id);
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {},
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
              // style: TextStyle(fontFamily: 'Lato'),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {},
              color: Theme.of(context).colorScheme.secondary,
            )),
      ),
    );
  }
}
