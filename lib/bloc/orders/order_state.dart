part of 'order_bloc.dart';

abstract class OrderState extends Equatable {}

class OrderInitialState extends OrderState {
  @override
  List<Object?> get props => [];
}

class OrderLoadingState extends OrderState {
  @override
  List<Object?> get props => [];
}

class OrderAdding extends OrderState {
  @override
  List<Object?> get props => [];
}

class OrderAdded extends OrderState {
  @override
  List<Object?> get props => [];
}

class OrderLoadedState extends OrderState {
  OrderLoadedState(this.orders);
  final List<OrderItem> orders;
  @override
  List<Object?> get props => [orders];
}

class OrderError extends OrderState {
  final String error;
  OrderError(this.error);

  @override
  List<Object?> get props => [error];
}
