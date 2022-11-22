import 'package:flutter/material.dart';

import '../screens/products_details_screen.dart';
import '../models/products.dart';
import '../bloc/bloc_exports.dart';
import '../models/cart.dart';
import '../helpers/guid_gen.dart';

import '../screens/cart_screen.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  void _selectProductDetails(BuildContext ctx, String? id, Product product) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          product: product,
        ),
      ),
    );
    /* Navigator.of(ctx).pushNamed(
      ProductDetailsScreen.routeName,
      arguments: id,
    );*/
  }

  int i = 1;

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    //  var cartItem = BlocProvider.of<CartBloc>(context);
    /* final product = Provider.of<Product>(context,
        listen:
            false); //listen to false only rebuilds the particular section you want to build
    final cart = Provider.of<Cart>(context, listen: false);

    final user = Provider.of<Auth>(context, listen: false);*/

    return ClipRRect(
      //this forces its child widget to take a certain shape
      borderRadius: BorderRadius.circular(10),

      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          leading: /*Consumer<Product>(
            builder: (__, product, _) => */
              IconButton(
            icon: Icon(
              widget.product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              // product.toggleFavoriteStatus(user.userId, user.token);
            },
          ),
          //),
          title: Text(
            widget.product.title.toString(),
            textAlign: TextAlign.center,
          ),
          trailing: BlocBuilder<CartBloc, CartStateLoaded>(
            // bloc: cartItem,
            builder: (context, state) {
              List<CartItem> cart1 = state.addedTask;
              print(i);
              return Row(
                children: [
                  IconButton(
                      icon: const Icon(
                        Icons.add,
                      ),
                      onPressed: () {}),
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                    ),
                    onPressed: () {
                      var cart = CartItem(
                        id: GuidGen.generate(),
                        title: widget.product.title,
                        quantity: 1,
                        price: widget.product.price,
                      );
                      if (state.addedTask.isEmpty) {
                        const Center();
                      }
                      if (isSelected == false) {
                        addCart(cart, context);
                        setState(() {
                          isSelected = true;
                        });
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CartScreen(
                                //cart: cart,
                                // state: state,
                                ),
                          ),
                        );
                        //  setState(() {
                        /* i++;
                        // });
                        var editCart1 = CartItem(
                          id: cart.id,
                          title: cart.title,
                          quantity: i,
                          price: cart.price,
                        );
                        editCart(cart, editCart1, context);*/
                      }

                      //  if (cart1.contains(cart)) {

                      //  }
                      /*items.putIfAbsent(cart.id!, () {
                    
                    return CartItem(
                      id: GuidGen.generate(),
                      title: product.title,
                      quantity: 1,
                      price: product.price,
                    );
                  });*/

                      //  if (items.containsKey(cart.id)) {

                      /* items.update(cart.id!, (exist) {
                      
                      return CartItem(
                        id: cart.id,
                        title: cart.title,
                        quantity: cart.quantity + 1,
                        price: cart.price,
                      );
                    });*/
                      // }
                      /*  cart.addItem(
                product.title,
                product.price,
                product.title,
              );*/
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Added item to cart!'),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            //  cart.removeSingleItem(product.id);
                          },
                        ),
                      ));
                    },
                    color: Theme.of(context).accentColor,
                  ),
                ],
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () => _selectProductDetails(
              context, widget.product.id.toString(), widget.product),
          child: Hero(
            tag: widget.product.title,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(widget.product.imageUrl),
              fit: BoxFit
                  .cover, //to make the image the same size of the container
            ),
          ),
        ),
      ),
    );
  }

  addCart(CartItem cart, BuildContext context) {
    context.read<CartBloc>().add(
          AddCart(
            cart: cart,
          ),
        );
  }

  void editCart(CartItem oldCart, CartItem newCart, BuildContext context) {
    context.read<CartBloc>().add(
          EditCart(
            oldCart: oldCart,
            newCart: newCart,
          ),
        );
  }
}
