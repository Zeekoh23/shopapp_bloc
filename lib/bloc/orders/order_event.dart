part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderCreate extends OrderEvent {
  final double amount;
  final String userId;
  final List<CartItem> cartProducts;

  OrderCreate(
    this.amount,
    this.userId,
    this.cartProducts,
  );
}

class LoadOrderEvent extends OrderEvent {
  @override
  List<Object> get props => [];
}
