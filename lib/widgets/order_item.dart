import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/orders.dart';

class OrderItem1 extends StatefulWidget {
  final OrderItem order;

  const OrderItem1({Key? key, required this.order}) : super(key: key);

  @override
  _OrderItem1State createState() => _OrderItem1State();
}

class _OrderItem1State extends State<OrderItem1> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    //print('orders is ' + widget.order.toString());
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.order.products.length * 1000.0 + 100, 800)
          : 93,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${double.parse(widget.order.amount.toString())}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.order.products.length * 500.0 + 10, 700)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            prod.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${prod.quantity}x \$${double.parse(prod.price.toString())}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
    // },
    // );
  }
}
