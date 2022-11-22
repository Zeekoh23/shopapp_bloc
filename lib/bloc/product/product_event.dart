part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
  //const ProductEvent();
}

class LoadProductEvent extends ProductEvent {
  @override
  List<Object> get props => [];
}

class ProductCreate extends ProductEvent {
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool isFavorite;
  final String userId;

  ProductCreate(
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavorite,
    this.userId,
  );
}

class ProductEdited extends ProductEvent {
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool isFavorite;
  final String id;

  ProductEdited(
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavorite,
    this.id,
  );
}

class ProductDelete extends ProductEvent {
  final String id;
  ProductDelete(this.id);
}
