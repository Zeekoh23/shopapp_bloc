import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/bloc_exports.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.state,
    required this.scaffoldKey,
    // required this.totalAmount,
    // required this.cart,
    //  this.title,
    //this.length,
  }) : super(key: key);
  final CartStateLoaded? state;
  final GlobalKey<ScaffoldState> scaffoldKey;

  // final double totalAmount;
  // final Cart cart;
  // final String? title;
  // final int? length;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  final orderApi = OrderApi();

  @override
  Widget build(BuildContext context) {
    //final carts = Provider.of<Cart>(context, listen: false);

    return BlocProvider(
      create: (context) => OrderBloc(
        orderApi: orderApi, //RepositoryProvider.of<ApiRead>(context),
      ),
      child: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order added'),
                duration: Duration(seconds: 5),
              ),
            );
          }
        },
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderAdding) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OrderError) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return TextButton(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () async {
                  double amount = 0.0;
                  for (var item in widget.state!.addedTask) {
                    amount += item.price * item.quantity;
                  }
                  final pref = await SharedPreferences.getInstance();
                  final extractData = json.decode(pref.getString('userData')!)
                      as Map<String, dynamic>;
                  final userId = extractData['userId'] as String;
                  print('double is $amount');
                  _postOrder(
                    context: context,
                    amount: amount,
                    userId: userId,
                  );
                  _deleteAllCarts(context: context);
                }
                /* (/*widget.state!.totalAmount! <= 0 || _isLoading)
          ? null
          :*/
              () async {
        setState(() {
          _isLoading = true;
        });
        /* await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );*/

        setState(() {
          _isLoading = false;
        });
        context.read<CartBloc>().add(
              DeleteAllCarts(),
              //DeleteCart(cart: cart)
            );
        // widget.cart.clear();
      })*/
                ,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('ORDER NOW'),
              );
            }
          },
        ),
      ),
    );
  }

  void _postOrder({
    required BuildContext context,
    required double amount,
    required String userId,
  }) {
    context.read<OrderBloc>().add(
          OrderCreate(
            amount,
            userId,
            widget.state!.addedTask,
          ),
        );
    /* BlocProvider.of<OrderBloc>(context).add(
      OrderCreate(
        amount,
        userId,
        widget.state!.addedTask,
      ),
    );*/
  }

  _deleteAllCarts({required BuildContext context}) {
    context.read<CartBloc>().add(
          DeleteAllCarts(),
          //DeleteCart(cart: cart)
        );
  }
}
