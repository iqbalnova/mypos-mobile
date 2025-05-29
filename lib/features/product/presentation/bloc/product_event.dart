part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

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
