import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as nf;
import '../models/cart.dart';
import '../bloc/bloc_exports.dart';

final format = nf.NumberFormat.currency(name: '');

class CartItem1 extends StatelessWidget {
  final String productId;
  // final String id;

  final double price;
  final int quantity;
  final String title;
  final CartItem cart;

  CartItem1(
    this.productId,
    this.cart,
    //this.id,
    this.price,
    this.quantity,
    this.title,
  );
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Dismissible(
          key: ValueKey(productId),
          background: Container(
            color: Theme.of(context).errorColor,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(
              right: 20,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {
            return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                        title: const Text(
                          'Are you sure?',
                        ),
                        content: const Text(
                          'Do you want to remove the item from the cart?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    // DeleteAllCarts(),
                                    DeleteCart(cart: cart),
                                  );
                              Navigator.of(ctx).pop(true);
                            },
                          ),
                        ]));
          },
          onDismissed: (direction) {
            // Provider.of<Cart>(context, listen: false).removeItem(productId);
          },
          child: Container(
            height: 100,
            child: Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(
                          child: Text('$price'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width / 17,
                    ),
                    SizedBox(
                      height: 80,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$quantity $title'),
                          const SizedBox(
                            height: 2,
                          ),
                          Text('Total: \$${format.format(price * quantity)}'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width / 7,
                    ),
                    Container(
                      width: 120,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              iconButton(
                                context: context,
                                icon: const Icon(
                                  Icons.remove,
                                  //size: 20,
                                ),
                                onPressed: () {
                                  if (quantity > 1) {
                                    int quant = quantity;

                                    quant--;

                                    var newCart = CartItem(
                                      id: productId,
                                      title: title,
                                      quantity: quant,
                                      price: price,
                                    );
                                    context.read<CartBloc>().add(
                                          EditCart(
                                            oldCart: cart,
                                            newCart: newCart,
                                          ),
                                        );
                                  }
                                },
                              ),
                              iconButton(
                                context: context,
                                icon: const Icon(
                                  Icons.add,
                                ),
                                onPressed: () {
                                  var oldCart = CartItem(
                                    id: productId,
                                    title: title,
                                    quantity: quantity,
                                    price: price,
                                  );
                                  int quant = quantity;
                                  quant++;

                                  var newCart = CartItem(
                                    id: productId,
                                    title: title,
                                    quantity: quant,
                                    price: price,
                                  );
                                  context.read<CartBloc>().add(
                                        EditCart(
                                          oldCart: oldCart,
                                          newCart: newCart,
                                        ),
                                      );
                                },
                              ),
                              iconButton(
                                context: context,
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                        // DeleteAllCarts(),
                                        DeleteCart(cart: cart),
                                      );
                                  /*Provider.of<Cart>(context, listen: false)
                      .removeSingleItem(productId);*/
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Removed item from cart!',
                                      ),
                                      duration: const Duration(
                                        seconds: 3,
                                      ),
                                      action: SnackBarAction(
                                        label: 'UNDO',
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                                AddCart(cart: cart),
                                              );
                                          /*Provider.of<Cart>(context, listen: false).addItem(
                            id,
                            price,
                            title,
                          );*/
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /* ListTile(
                  leading: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: FittedBox(
                        child: Text('$price'),
                      ),
                    ),
                  ),
                  title: Text('$quantity $title'),
                  subtitle: Text('Total: \$${price * quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<CartBloc>().add(
                            // DeleteAllCarts(),
                            DeleteCart(cart: cart),
                          );
                      /*Provider.of<Cart>(context, listen: false)
                      .removeSingleItem(productId);*/
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                            'Removed item from cart!',
                          ),
                          duration: const Duration(
                            seconds: 3,
                          ),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    AddCart(cart: cart),
                                  );
                              /*Provider.of<Cart>(context, listen: false).addItem(
                            id,
                            price,
                            title,
                          );*/
                            },
                          )));
                    },
                    color: Theme.of(context).accentColor,
                  ),
                )),*/
            ),
          ),
        );
      },
    );
  }

  Widget iconButton({
    required BuildContext context,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      color: Theme.of(context).accentColor,
    );
  }
}
