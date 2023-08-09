import 'package:flutter/material.dart';

import '../models/products.dart';
import '../widgets/user_products_item.dart';
import '../widgets/app_drawer.dart';
import './edit_add_userproducts_screen.dart';
import '../bloc/bloc_exports.dart';

// ignore: must_be_immutable
class UserProductsScreen extends StatelessWidget {
  UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products';

  String id = '';
  final productApi = ProductApi();

  @override
  Widget build(BuildContext context) {
    //  final productsData = Provider.of<ProductsProvider>(context, listen: false);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(
                    id: id,
                  ),
                ),
              );
              /* Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);*/
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: BlocProvider(
        create: (ctx) => ProductBloc(
          productApi,
        )..add(LoadProductEvent()),
        child: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          },
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoadingState) {
                return const Center(
                    child:
                        CircularProgressIndicator() //for the loading spinner,
                    );
              }
              if (state is ProductLoadedState) {
                List<Product> products = state.products;

                /* RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child:*/
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        return Column(
                          children: [
                            UserProductItem(
                              products[i].id,
                              products[i].title,
                              products[i].imageUrl,
                              products[i],
                            ),
                            const Divider(),
                          ],
                        );
                      }),
                  // ),
                  // ),
                );
              }

              return const SizedBox();
            },
          ),
        ),

        /*FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                :*/
      ),
    );
    // ),
  }
}
