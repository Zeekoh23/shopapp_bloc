import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ProductModel {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  final bool? isFavorite;
  final String? userId;

  ProductModel({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavorite,
    this.userId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        price: json['price'],
        isFavorite: json['isFavorite'],
        userId: json['userId'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'isFavorite': isFavorite,
        'userId': userId,
      };
}

class Product with ChangeNotifier {
  final String id;
  final String? productId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.productId,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  var log = Logger();

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse('http://10.0.2.2:3001/api/v1/products/:$id');
    final headers = {"Content-type": "application/json"};
    try {
      final res = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      final extract = json.decode(res.body);
      log.i(extract);

      /*if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }*/
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
