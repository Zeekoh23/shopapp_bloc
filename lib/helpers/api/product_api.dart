import 'dart:convert';

import 'package:logger/logger.dart';

import '../api.dart';
import '../../models/products.dart';
import '../api_route.dart';

class ProductApi {
  var log = Logger();
  Future<ResponseApi> productListRequest() async {
    final response = await Api.getRequest(ApiRoute.productUrl);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final res = json.decode(response.body);
    if (response.statusCode == 200) {
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            productId: prodData['_id'],
            title: prodData['title'],
            description: prodData['description'],
            price: double.parse(prodData['price'].toString()),
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      log.d(extractedData);

      return ResponseApi(
        status: true,
        message: 'Products retrieved',
        data: loadedProducts,
      );
    }
    return ResponseApi(status: false, message: res['message']);
  }

  Future<ResponseApi> addProduct({
    required String title,
    required String description,
    required double price,
    required String imageUrl,
    required bool isFavorite,
    required String userId,
  }) async {
    final response = await Api.postRequest(
      ApiRoute.productUrl,
      {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'isFavorite': isFavorite,
        'userid': userId,
      },
    );
    final responseData = json.decode(response.body);
    log.d(responseData);
    if (response.statusCode != 400 || response.statusCode != 500) {
      return ResponseApi(
        status: true,
        message: 'Product posted',
        data: responseData,
      );
    } else {
      return ResponseApi(
        status: false,
        message: responseData['message'],
      );
    }
  }

  Future<ResponseApi> editProduct({
    required String title,
    required String description,
    required double price,
    required String imageUrl,
    required bool isFavorite,
    required String id,
  }) async {
    final response = await Api.postRequest(
      '${ApiRoute.productUrl}/$id',
      {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
      },
    );
    final responseData = json.decode(response.body);
    log.d(responseData);

    if (response.statusCode != 400 || response.statusCode != 500) {
      return ResponseApi(
        status: true,
        message: 'Product edited',
        data: responseData,
      );
    } else {
      return ResponseApi(
        status: false,
        message: responseData['message'],
      );
    }
  }

  Future<ResponseApi> deleteProduct(String id) async {
    final response = await Api.deleteRequest('${ApiRoute.productUrl}/$id');
    //final responseData = json.decode(response.body);
    log.d(response);
    if (response.statusCode != 400 || response.statusCode != 500) {
      return ResponseApi(
        status: true,
        message: 'Product deleted',
      );
    } else {
      return ResponseApi(
        status: false,
        message: 'Product failed',
      );
    }
  }
}
