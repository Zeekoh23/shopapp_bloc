import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as badges;

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';

import '../bloc/bloc_exports.dart';

//import '../bloc/product/product_bloc.dart';

import './cart_screen.dart';
import '../models/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  //String id;

  /* @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }*/
  final productApi = ProductApi();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ProductBloc(
        productApi,
        //RepositoryProvider.of<ApiRead>(context),
      )..add(LoadProductEvent()),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartStateLoaded) {
            // List<CartItem> cart = state.addedTask;
            return Scaffold(
              appBar: AppBar(
                title: const Text('MyShop'),
                actions: <Widget>[
                  PopupMenuButton(
                    onSelected: (FilterOptions selectedValue) {
                      setState(() {
                        if (selectedValue == FilterOptions.Favorites) {
                          _showOnlyFavorites = true;
                        } else {
                          _showOnlyFavorites = false;
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.more_vert,
                    ),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.Favorites,
                      ),
                      const PopupMenuItem(
                        child: Text('Show All'),
                        value: FilterOptions.All,
                      ),
                    ],
                  ),
                  /*  Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
                color: Theme.of(context).accentColor,
              ),
              child: */
                  badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Theme.of(context).focusColor,
                    ),
                    //value: cart.length.toString(),

                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                      ),
                      onPressed: () {
                        if (state.addedTask.isEmpty) {
                          const Center();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CartScreen(
                                  //cart: cart,
                                  // state: state,
                                  ),
                            ),
                          );
                        }

                        //Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  )

                  // ),
                ],
              ),
              drawer: AppDrawer(),
              body: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  print(state);
                  if (state is ProductLoadingState) {
                    return const Center(
                        child:
                            CircularProgressIndicator() //for the loading spinner,
                        );
                  }
                  if (state is ProductLoadedState) {
                    List<Product> products = state.products;

                    return ProductsGrid(
                      showFavs: _showOnlyFavorites,
                      product: products,
                    );
                  }
                  if (state is ProductErrorState) {
                    return Center(
                      child: Text(state.error),
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );

    /* RefreshIndicator(
          //when you drag the app to load the app
          onRefresh: () => _refreshProducts(context),
          child: _isLoading
              ? 
              : ProductsGrid(_showOnlyFavorites),
        ))*/
  }
}
