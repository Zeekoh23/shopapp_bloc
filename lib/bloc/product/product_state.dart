part of 'product_bloc.dart';

abstract class ProductState extends Equatable {}

class ProductInitialState extends ProductState {
  @override
  List<Object?> get props => [];
}

//data loading state
class ProductLoadingState extends ProductState {
  @override
  List<Object?> get props => [];
}

//data loaded state
class ProductLoadedState extends ProductState {
  ProductLoadedState(this.products);
  final List<Product> products;

  @override
  List<Object?> get props => [products];
}

//error loading state
class ProductErrorState extends ProductState {
  ProductErrorState(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

class ProductAdding extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductAdded extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductEdited1 extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductDeleting extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductDeleted extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductDeleteState extends ProductState {
  ProductDeleteState(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
