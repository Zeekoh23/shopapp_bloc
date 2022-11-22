import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../models/orders.dart';
import '../bloc/bloc_exports.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  //you can use both initState or didChangeDependencies
  //by default initState is not an async function

  /* Future<void> _obtainOrdersFuture() async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }*/

  @override
  void initState() {
    // _obtainOrdersFuture();

    super.initState();
  }

  final orderApi = OrderApi();

  @override
  Widget build(BuildContext context) {
    print('building orders');
    return BlocProvider(
      create: (ctx) => OrderBloc(
          orderApi: orderApi //RepositoryProvider.of<ApiRead>(context),
          )
        ..add(LoadOrderEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your orders'),
        ),
        drawer: AppDrawer(),
        body: /* FutureBuilder(
          future: _obtainOrdersFuture(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot == null) {
                return const Center(
                  child: Text('An error occurred!'),
                );
              } else {*/
            BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            //  print(state);
            if (state is OrderLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is OrderLoadedState) {
              // print(state.orders);
              List<OrderItem> orders = state.orders;
              return ListView.builder(
                itemCount: orders.length, //orderData.orders.length,
                itemBuilder: (ctx, i) {
                  return OrderItem1(order: orders[i]);
                },
              );
              //);
            }
            if (state is OrderError) {
              return Center(
                child: Text(state.error),
              );
            }
            return const Text('abejkdk');
          },
        ),

        //   }
        // }
        //  },
        //),
      ),
    );
  }
}
