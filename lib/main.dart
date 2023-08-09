import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import './bloc/bloc_exports.dart';

import './screens/products_overview_screen.dart';

import './screens/cart_screen.dart';

import './screens/orders_screen.dart';
import './bloc/cart/cart_bloc.dart';
import './screens/user_products_screen.dart';

import 'helpers/api/auth_api.dart';
import './models/products.dart';

import '../models/orders.dart';

import './screens/auth_screen.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // print(event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //DartPluginRegistrant.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  Bloc.observer = SimpleBlocObserver();
  final authApi = AuthApi();
  //BlocObserver = SimpleBlocObserver();
  /*HydratedBlocOverrides.runZoned(
    () {
      return */
  runApp(
    BlocProvider<AuthBloc>(
      create: (context) {
        return AuthBloc(authApi: authApi)..add(AppStarted());
      },
      child: MyApp(authApi: authApi),
    ),
  );
  /* },
    blocObserver: SimpleBlocObserver(),
    storage: storage,
  );*/
}

class MyApp extends StatefulWidget {
  final AuthApi authApi;
  const MyApp({Key? key, required this.authApi}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = '';
  String userId = '';
  String email = '';

  String? id;
  List<Product> prod = [];
  List<OrderItem> ord = [];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return /*MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (c) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previousProduct) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProduct == null
                  ? []
                  : previousProduct
                      .items), //this only works within the screen size or when you are calling an instance of a class

          create: (ctx) => ProductsProvider(token, userId, prod),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          update: (ctx, auth, previousCart) => Cart(auth.token, auth.userId),
          create: (ctx) => Cart(token, userId),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
          create: (ctx) => Orders(token, userId, ord),
        ),
      ],
      child:*/ /* Consumer<Auth>(
        builder: (ctx, auth, _) =>*/
        MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: /*RepositoryProvider(
        create: (ctx) => ApiRead(),
        child:*/
          MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          //primaryColor: Colors.purple,
          primarySwatch: Colors.purple,
          focusColor: Colors.deepOrange,
          //accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          /*pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          }),*/
        ),

        home: /*auth.isAuth
              ?*/
            BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return ProductsOverviewScreen();
            }
            if (state is AuthUnAuthenticated) {
              return AuthScreen(authApi: widget.authApi);
            }
            if (state is AuthLoading) {
              return const Scaffold(
                body: CircularProgressIndicator(),
              );
            }
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          },
        ),

        // ,
        //),
        // ),
        //),

        /*: FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authRes) =>
                      authRes.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),*/
        //initialRoute: '/',
        routes: {
          // ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          //EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
      // ),
    );
    //  ),
    // );
  }
}
