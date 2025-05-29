import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_form_model.dart';
import '../../domain/usecases/delete_products.dart';
import '../../domain/usecases/update_products.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/add_products.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/update_category.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  // Category
  final GetCategories getCategories;
  final AddCategory addCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;
  // Product
  final GetProducts getProducts;
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductBloc({
    // Category
    required this.getCategories,
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
    // Product
    required this.getProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(ProductInitial()) {
    // Category
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    // Product
    on<FetchProductsEvent>(_onFetchProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  // Category
  Future<void> _onFetchCategories(
    FetchCategoriesEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(CategoryLoading());

    final result = await getCategories.execute();

    result.fold(
      (failure) => emit(CategoryError("Failed to fetch categories")),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(CategoryManagementLoading());

    final result = await addCategory.execute(event.name);

    result.fold(
      (failure) => emit(AddCategoryFailure(failure.message)),
      (_) => emit(AddCategorySuccess()),
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(CategoryManagementLoading());

    final result = await updateCategory.execute(event.id, event.name);

    result.fold(
      (failure) => emit(UpdateCategoryFailure(failure.message)),
      (_) => emit(UpdateCategorySuccess(event.name)),
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(CategoryManagementLoading());

    final result = await deleteCategory.execute(event.id);

    result.fold(
      (failure) => emit(DeleteCategoryFailure(failure.message)),
      (_) => emit(DeleteCategorySuccess()),
    );
  }

  // Product
  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await getProducts.execute();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }

  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await addProduct.execute(event.formModel, event.imageFile);
    result.fold(
      (failure) => emit(AddProductFailure(failure.message)),
      (_) => emit(AddProductSuccess()),
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await updateProduct.execute(
      event.id,
      event.formModel,
      event.imageFile,
    );
    result.fold(
      (failure) => emit(UpdateProductFailure(failure.message)),
      (_) => emit(UpdateProductSuccess()),
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await deleteProduct.execute(event.id);
    result.fold(
      (failure) => emit(DeleteProductFailure(failure.message)),
      (_) => emit(DeleteProductSuccess()),
    );
  }
}
