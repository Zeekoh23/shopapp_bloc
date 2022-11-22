part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddCart extends CartEvent {
  final CartItem cart;
  const AddCart({
    required this.cart,
  });

  @override
  List<Object> get props => [cart];
}

class EditCart extends CartEvent {
  final CartItem oldCart;
  final CartItem newCart;

  const EditCart({
    required this.oldCart,
    required this.newCart,
  });

  @override
  List<Object> get props => [
        oldCart,
        newCart,
      ];
}

class DeleteCart extends CartEvent {
  final CartItem cart;
  const DeleteCart({
    required this.cart,
  });

  @override
  List<Object> get props => [cart];
}

class DeleteAllCarts extends CartEvent {}

class LoadCart extends CartEvent {
  @override
  List<Object> get props => [];
}
