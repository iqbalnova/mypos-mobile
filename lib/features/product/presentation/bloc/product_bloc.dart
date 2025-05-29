import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetCategories getCategories;

  ProductBloc({required this.getCategories}) : super(ProductInitial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<ProductState> emit,
  ) async {
    emit(CategoryLoading());

    final result = await getCategories.execute();

    result.fold(
      (failure) => emit(CategoryError("Failed to fetch categories")),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}
