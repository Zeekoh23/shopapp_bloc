import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../api.dart';
import '../../models/orders.dart';
import '../../models/cart.dart';

import '../api_route.dart';

class OrderApi {
  var log = Logger();
  Future<ResponseApi> addOrder(
      double total, List<CartItem> cartProducts, String userId) async {
    final timestamp = DateTime.now();
    final response = await Api.postRequest(ApiRoute.orderUrl, {
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts
          .map(
            (cp) => {
              'id': cp.id,
              'title': cp.title,
              'quantity': cp.quantity,
              'price': cp.price,
            },
          )
          .toList(),
      'userid': userId,
    });
    final responseData = json.decode(response.body);

    if (response.statusCode != 400 || response.statusCode != 500) {
      return ResponseApi(
        status: true,
        message: 'Order Posted',
        data: responseData,
      );
    } else {
      return ResponseApi(
        status: false,
        message: responseData['message'],
      );
    }
  }

  Future<ResponseApi> orderListRequest() async {
    final pref = await SharedPreferences.getInstance();
    final extractData =
        json.decode(pref.getString('userData')!) as Map<String, dynamic>;
    final userId1 = extractData['userId'] as String;

    final response =
        await Api.getRequest('${ApiRoute.orderUrl}?userid=$userId1');
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 400 || response.statusCode != 500) {
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id1: orderId,
            amount: double.parse(orderData['amount'].toString()),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    title: item['title'],
                    quantity: item['quantity'],
                    price: double.parse(item['price'].toString()),
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      // log.d(extractedData);
      return ResponseApi(
        status: true,
        message: 'Orders retrieved',
        data: loadedOrders,
      );
    }
    return ResponseApi(
      status: false,
      message: extractedData['message'],
    );
  }
}
