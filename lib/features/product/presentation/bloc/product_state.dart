part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

// CATEGORY
class CategoryLoading extends ProductState {}

class CategoryLoaded extends ProductState {
  final List<Category> categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends ProductState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryManagementLoading extends ProductState {}

// ADD category states
class AddCategorySuccess extends ProductState {}

class AddCategoryFailure extends ProductState {
  final String message;

  const AddCategoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// UPDATE category states
class UpdateCategorySuccess extends ProductState {
  final String name;

  const UpdateCategorySuccess(this.name);

  @override
  List<Object?> get props => [name];
}

class UpdateCategoryFailure extends ProductState {
  final String message;

  const UpdateCategoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// DELETE category states
class DeleteCategorySuccess extends ProductState {}

class DeleteCategoryFailure extends ProductState {
  final String message;

  const DeleteCategoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// PRODUCT
class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class AddProductSuccess extends ProductState {}

class UpdateProductSuccess extends ProductState {}

class DeleteProductSuccess extends ProductState {}

class AddProductFailure extends ProductState {
  final String message;

  const AddProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateProductFailure extends ProductState {
  final String message;

  const UpdateProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteProductFailure extends ProductState {
  final String message;

  const DeleteProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

// CART
class CartLoading extends ProductState {}

class CartLoaded extends ProductState {
  final List<CartItem> cartItems;
  final double totalPrice;
  final int totalItems;

  const CartLoaded({
    required this.cartItems,
    required this.totalPrice,
    required this.totalItems,
  });

  @override
  List<Object> get props => [cartItems, totalPrice, totalItems];
}

class CartError extends ProductState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

class CartItemAdded extends ProductState {
  final CartItem cartItem;

  const CartItemAdded(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

class CartItemUpdated extends ProductState {
  final CartItem cartItem;

  const CartItemUpdated(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}

class CartItemRemoved extends ProductState {}

class CartCleared extends ProductState {}
