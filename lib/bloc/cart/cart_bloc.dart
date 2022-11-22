import 'package:equatable/equatable.dart';

import '../../models/cart.dart';
import '../bloc_exports.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends HydratedBloc<CartEvent, CartStateLoaded> {
  CartBloc() : super(CartStateLoaded()) {
    on<AddCart>(_onAddCart);
    on<EditCart>(_onEditCart);
    on<DeleteCart>(_onDeleteCart);
    on<DeleteAllCarts>(_onDeleteAllCarts);
    on<LoadCart>(_totalAmount);
  }

  void _onAddCart(AddCart event, Emitter<CartState> emit) {
    final state = this.state;
    //  if (state is CartStateLoaded) {
    try {
      emit(
        CartStateLoaded(
          addedTask: List.from(state.addedTask)
            ..add(
              event.cart,
            ),
        ),
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
    // }
  }

  void _onEditCart(EditCart event, Emitter<CartState> emit) {
    final state = this.state;
    // if (state is CartStateLoaded) {
    try {
      emit(
        CartStateLoaded(
          addedTask: List.from(state.addedTask)
            ..remove(event.oldCart)
            ..insert(0, event.newCart),
        ),
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
    // }
  }

  void _onDeleteCart(DeleteCart event, Emitter<CartState> emit) {
    final state = this.state;
    //  if (state is CartStateLoaded) {
    try {
      emit(
        CartStateLoaded(
          addedTask: List.from(state.addedTask)
            ..remove(
              event.cart,
            ),
        ),
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
    // }
  }

  void _onDeleteAllCarts(DeleteAllCarts event, Emitter<CartState> emit) {
    final state = this.state;
    // if (state is CartStateLoaded) {
    try {
      emit(
        CartStateLoaded(
          addedTask: List.from(state.addedTask)..clear(),
        ),
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
    // }
  }

  void _totalAmount(LoadCart event, Emitter<CartState> emit) {
    emit(CartStateLoaded());
    final state = this.state;

    //Map<String, CartItem> _items = {};
    var total = 0.0;
    for (var item in state.addedTask) {
      total += item.price * item.quantity;
    }
    /*_items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });*/
    emit(
      CartStateLoaded(
        addedTask: List.from(state.addedTask),
        totalAmount: total,
      ),
    );
  }

  @override
  CartStateLoaded? fromJson(Map<String, dynamic> json) {
    return CartStateLoaded.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(CartStateLoaded state) {
    return state.toMap();
  }
}
