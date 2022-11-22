import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/user_products_screen.dart';

import '../screens/orders_screen.dart';
import '../bloc/bloc_exports.dart';

import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello friend'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          const Divider(),
          ListTile(
              leading: const Icon(
                Icons.payment,
              ),
              title: const Text('Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(
                Icons.edit,
              ),
              title: const Text('User Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context)
                    .pop(); //to ensure it does not lead to another route apart from auth screen
                Navigator.of(context).pushReplacementNamed('/');
                BlocProvider.of<AuthBloc>(context).add(
                  LoggedOut(),
                );
                // Provider.of<Auth>(context, listen: false).logout();
              })
        ],
      ),
    );
  }
}
