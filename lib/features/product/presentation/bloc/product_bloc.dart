import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/update_category.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetCategories getCategories;
  final AddCategory addCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;

  ProductBloc({
    required this.getCategories,
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }) : super(ProductInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

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
}
