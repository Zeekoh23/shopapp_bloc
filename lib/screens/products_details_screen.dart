import 'package:flutter/material.dart';

import '../models/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/productdetails';
  const ProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    /*  final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(
            productId); */ //listening is set to false because no changes in this widget
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 300,
          pinned: true, //appbar will stick at the top
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              product.title,
            ),
            background: Hero(
              tag: product.title,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(height: 10),
          Text(
            '\$${product.price}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: double.infinity,
              child: Text(
                product.description,
                softWrap: true,
              )),
          const SizedBox(height: 800),
        ])),
      ]),
    );
  }
}
