part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// CATEGORIES
class FetchCategoriesEvent extends ProductEvent {}

class AddCategoryEvent extends ProductEvent {
  final String name;

  const AddCategoryEvent(this.name);

  @override
  List<Object> get props => [name];
}

class UpdateCategoryEvent extends ProductEvent {
  final String id;
  final String name;

  const UpdateCategoryEvent(this.id, this.name);

  @override
  List<Object> get props => [id, name];
}

class DeleteCategoryEvent extends ProductEvent {
  final String id;

  const DeleteCategoryEvent(this.id);

  @override
  List<Object> get props => [id];
}

// PRODUCTS
class FetchProductsEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final ProductFormModel formModel;
  final File imageFile;

  const AddProductEvent({required this.formModel, required this.imageFile});
}

class UpdateProductEvent extends ProductEvent {
  final String id;
  final ProductFormModel formModel;
  final File? imageFile;

  const UpdateProductEvent({
    required this.id,
    required this.formModel,
    this.imageFile,
  });
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  const DeleteProductEvent(this.id);

  @override
  List<Object> get props => [id];
}

// CART
class LoadCartItems extends ProductEvent {}

class AddCartItemEvent extends ProductEvent {
  final CartItem cartItem;

  const AddCartItemEvent(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

class UpdateCartItemEvent extends ProductEvent {
  final CartItem cartItem;

  const UpdateCartItemEvent(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

class IncrementQuantity extends ProductEvent {
  final String productId;

  const IncrementQuantity(this.productId);

  @override
  List<Object> get props => [productId];
}

class DecrementQuantity extends ProductEvent {
  final String productId;

  const DecrementQuantity(this.productId);

  @override
  List<Object> get props => [productId];
}

class RemoveCartItemEvent extends ProductEvent {
  final String productId;

  const RemoveCartItemEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class BulkRemoveCartItemEvent extends ProductEvent {
  final List<String> productIds;

  const BulkRemoveCartItemEvent(this.productIds);

  @override
  List<Object?> get props => [productIds];
}

class ClearCartEvent extends ProductEvent {}
