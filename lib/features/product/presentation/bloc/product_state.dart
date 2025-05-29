part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

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

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
