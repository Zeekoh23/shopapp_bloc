import 'package:flutter/material.dart';

import './products_item.dart';
import '../models/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  final List<Product> product;

  const ProductsGrid({
    Key? key,
    required this.showFavs,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<ProductsProvider>(context);
    // final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: product.length,
      itemBuilder: (ctx,
              i) => /*ChangeNotifierProvider.value(
        // builder: (c) => products[i],
        value: product[i],
        child:*/
          ProductItem(
        product: product[i],
        // products[i].id,
        // products[i].title,
        // products[i].imageUrl,
      ),
      // ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
