import 'package:flutter/material.dart';

import '../widgets/cart_item.dart';
import '../bloc/bloc_exports.dart';

import '../models/cart.dart';
import './products_overview_screen.dart';
import '../widgets/order_button.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  CartScreen({
    Key? key,
    //this.cart,
    // this.state,
  }) : super(key: key);
  //final List<CartItem>? cart;
  // final CartState? state;

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    // final cart = Provider.of<Cart>(context);

    return BlocBuilder<CartBloc, CartStateLoaded>(
      builder: (context, state) {
        List<CartItem> cart = state.addedTask;
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    if (state.addedTask.isEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductsOverviewScreen(),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                const Text('Your cart'),
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Total',
                            style: TextStyle(fontSize: 20),
                          ),
                          const Spacer(), //this gives an equal amount of margin width between text and chip
                          /* Chip(
                          label: Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),*/
                          OrderButton(
                            state: state,
                            scaffoldKey: scaffoldKey,
                            // cart: cart,
                          ),
                        ]),
                  )),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (ctx, i) => CartItem1(
                    cart[i].id!,
                    cart[i],
                    //cart.items.keys.toList()[i],
                    cart[i].price,
                    cart[i].quantity,
                    cart[i].title,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
