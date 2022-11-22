import 'package:equatable/equatable.dart';

import '../../models/orders.dart';
import '../../models/cart.dart';

import '../bloc_exports.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderApi orderApi;
  OrderBloc({required this.orderApi}) : super(OrderInitialState()) {
    on<LoadOrderEvent>(_orderList);
    on<OrderCreate>(_orderCreate);
  }
  void _orderCreate(OrderCreate event, Emitter<OrderState> emit) async {
    emit(OrderAdding());
    await Future.delayed(const Duration(seconds: 1));
    final response = await orderApi.addOrder(
      event.amount,
      event.cartProducts,
      event.userId,
    );
    try {
      if (response.status) {
        emit(OrderAdded());
      } else {
        emit(OrderError(response.message));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  void _orderList(LoadOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());

    try {
      final response = await orderApi.orderListRequest();
      if (response.status) {
        var orders = response.data;
        emit(OrderLoadedState(orders));
      } else {
        emit(OrderError(response.message));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
