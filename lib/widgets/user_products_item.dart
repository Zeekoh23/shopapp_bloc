import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/products.dart';

import '../screens/edit_add_userproducts_screen.dart';

import '../bloc/bloc_exports.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Product product;

  UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
    this.product,
  );
  final productApi = ProductApi();

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return BlocProvider(
      create: (context) => ProductBloc(productApi),
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductDeleted) {
            scaffold.showSnackBar(
              const SnackBar(
                content: Text(
                  'Deleting Successful!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (state is ProductDeleteState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Deleting Failed!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
        child:
            BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
          if (state is ProductDeleting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListTile(
              title: Text(title),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
              trailing: Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(
                              id: id,
                              product: product,
                              //cart: cart,
                              // state: state,
                            ),
                          ),
                        );
                        /* Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);*/
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        context.read<ProductBloc>().add(
                              ProductDelete(product.productId!),
                            );
                        /* await Provider.of<ProductsProvider>(context,
                                listen: false)
                            .deleteProduct(id);*/
                      },
                      color: Theme.of(context).errorColor,
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
