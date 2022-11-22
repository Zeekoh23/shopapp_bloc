part of 'cart_bloc.dart';

abstract class CartState extends Equatable {}

/*
abstract class CartState extends Equatable{
  const CartState();
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState{
  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState{
  final CartItem? cart;
  const CartLoaded({this.cart = CartItem});
}
*/
class CartStateLoaded extends CartState {
  CartStateLoaded({
    this.addedTask = const <CartItem>[],
    this.totalAmount,
  });

  final List<CartItem> addedTask;
  final double? totalAmount;

  @override
  List<Object?> get props => [addedTask, totalAmount];

  Map<String, dynamic> toMap() {
    return {
      'addedTask': addedTask.map((x) => x.toMap()).toList(),
    };
  }

  factory CartStateLoaded.fromMap(Map<String, dynamic> map) {
    return CartStateLoaded(
      addedTask: List<CartItem>.from(
        map['addedTask']?.map(
          (x) => CartItem.fromMap(x),
        ),
      ),
    );
  }
}

class CartError extends CartState {
  CartError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

class TotalAmountState extends CartState {
  TotalAmountState(this.totalAmount);
  final double totalAmount;

  @override
  List<Object?> get props => [totalAmount];
}
