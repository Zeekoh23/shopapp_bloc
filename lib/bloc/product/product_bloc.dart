import 'package:equatable/equatable.dart';

import '../bloc_exports.dart';
import '../../models/products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductApi productApi;

  ProductBloc(this.productApi) : super(ProductInitialState()) {
    on<LoadProductEvent>(_productList);
    on<ProductCreate>(_productCreate);
    on<ProductEdited>(_productEdited);
    on<ProductDelete>(_productDeleted);
    // on<LoadProductEvent>((event, emit) async {});
  }

  void _productList(LoadProductEvent event, Emitter<ProductState> emit) async {
    // print('You emmited the first state');
    emit(ProductLoadingState());
    final response = await productApi.productListRequest();
    try {
      if (response.status) {
        var products = response.data;
        emit(ProductLoadedState(products));
      } else {
        emit(ProductErrorState(response.message));
      }
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  void _productCreate(ProductCreate event, Emitter<ProductState> emit) async {
    emit(ProductAdding());
    final response = await productApi.addProduct(
      title: event.title,
      description: event.description,
      price: event.price,
      imageUrl: event.imageUrl,
      isFavorite: event.isFavorite,
      userId: event.userId,
    );
    try {
      if (response.status) {
        emit(ProductAdded());
      } else {
        emit(ProductErrorState(response.message));
      }
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  void _productEdited(ProductEdited event, Emitter<ProductState> emit) async {
    emit(ProductAdding());
    final response = await productApi.editProduct(
      title: event.title,
      description: event.description,
      price: event.price,
      imageUrl: event.imageUrl,
      isFavorite: event.isFavorite,
      id: event.id,
    );
    try {
      if (response.status) {
        emit(ProductEdited1());
      } else {
        emit(ProductErrorState(response.message));
      }
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  void _productDeleted(ProductDelete event, Emitter<ProductState> emit) async {
    emit(ProductDeleting());
    final response = await productApi.deleteProduct(event.id);
    try {
      if (response.status) {
        emit(ProductDeleted());
      } else {
        emit(ProductDeleteState(response.message));
      }
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }
}

//this injects or combines event and states together

