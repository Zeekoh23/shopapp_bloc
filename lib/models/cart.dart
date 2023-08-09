import 'package:mongo_dart/mongo_dart.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CartItem extends Equatable {
  final String? id;
  final int? myid;
  final ObjectId? id1;
  String title;
  int quantity;
  double price;
  final String? orderid;

  CartItem(
      {this.id1,
      this.myid,
      this.id,
      required this.title,
      required this.quantity,
      required this.price,
      this.orderid});

  CartItem copyWith({
    String? id,
    int? myid,
    ObjectId? id1,
    String? title,
    int? quantity,
    double? price,
    String? orderid,
  }) {
    return CartItem(
      id: id ?? this.id,
      myid: myid ?? this.myid,
      id1: id1 ?? this.id1,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      orderid: orderid ?? this.orderid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'myid': myid,
      'id1': id1,
      'title': title,
      'quantity': quantity,
      'price': price,
      'orderid': orderid,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      myid: map['myid'],
      id1: map['id1'],
      title: map['title'],
      quantity: map['quantity'],
      price: map['price'],
      orderid: map['orderid'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        myid,
        id1,
        title,
        quantity,
        price,
        orderid,
      ];
}
