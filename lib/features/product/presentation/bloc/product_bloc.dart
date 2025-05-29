import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_cart_item.dart';
import '../../domain/usecases/bulk_remove_cart_item.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/remove_cart_item.dart';
import '../../domain/usecases/update_cart_item.dart';
import '../../data/models/product_form_model.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/delete_products.dart';
import '../../domain/usecases/get_cart_items.dart';
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
  // Cart
  final GetCartItems getCartItems;
  final AddCartItem addCartItem;
  final UpdateCartItem updateCartItem;
  final RemoveCartItem removeCartItem;
  final ClearCart clearCart;
  final BulkRemoveCartItem bulkRemoveCartItem;

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
    // Cart
    required this.getCartItems,
    required this.addCartItem,
    required this.updateCartItem,
    required this.removeCartItem,
    required this.clearCart,
    required this.bulkRemoveCartItem,
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
    // Cart
    on<LoadCartItems>(_onLoadCartItems);
    on<AddCartItemEvent>(_onAddCartItem);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<IncrementQuantity>(_onIncrementQuantity);
    on<DecrementQuantity>(_onDecrementQuantity);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<ClearCartEvent>(_onClearCart);
    on<BulkRemoveCartItemEvent>(_onBulkRemoveCartItem);
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

  // Cart
  Future<void> _onLoadCartItems(
    LoadCartItems event,
    Emitter<ProductState> emit,
  ) async {
    emit(CartLoading());

    final result = await getCartItems(NoParams());

    result.fold((failure) => emit(CartError(failure.toString())), (cartItems) {
      final totalPrice = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );
      final totalItems = cartItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

      emit(
        CartLoaded(
          cartItems: cartItems,
          totalPrice: totalPrice,
          totalItems: totalItems,
        ),
      );
    });
  }

  Future<void> _onAddCartItem(
    AddCartItemEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await addCartItem(CartItemParams(cartItem: event.cartItem));

    result.fold((failure) => emit(CartError(failure.toString())), (cartItem) {
      emit(CartItemAdded(cartItem));
      // add(LoadCartItems());
    });
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await updateCartItem(
      CartItemParams(cartItem: event.cartItem),
    );

    result.fold((failure) => emit(CartError(failure.toString())), (cartItem) {
      emit(CartItemUpdated(cartItem));
      add(LoadCartItems());
    });
  }

  Future<void> _onIncrementQuantity(
    IncrementQuantity event,
    Emitter<ProductState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = currentState.cartItems.firstWhere(
        (item) => item.productId == event.productId,
      );

      final updatedItem = item.copyWith(quantity: item.quantity + 1);
      add(UpdateCartItemEvent(updatedItem));
    }
  }

  Future<void> _onDecrementQuantity(
    DecrementQuantity event,
    Emitter<ProductState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = currentState.cartItems.firstWhere(
        (item) => item.productId == event.productId,
      );

      if (item.quantity > 1) {
        final updatedItem = item.copyWith(quantity: item.quantity - 1);
        add(UpdateCartItemEvent(updatedItem));
      } else {
        add(RemoveCartItemEvent(event.productId));
      }
    }
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await removeCartItem(
      RemoveCartItemParams(productId: event.productId),
    );

    result.fold((failure) => emit(CartError(failure.toString())), (_) {
      emit(CartItemRemoved());
      add(LoadCartItems());
    });
  }

  Future<void> _onBulkRemoveCartItem(
    BulkRemoveCartItemEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(CartLoading());

    final result = await bulkRemoveCartItem(
      BulkRemoveCartItemParams(productIds: event.productIds),
    );

    result.fold((failure) => emit(CartError(failure.toString())), (_) {
      emit(CartItemRemoved());
      add(LoadCartItems());
    });
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await clearCart(NoParams());

    result.fold((failure) => emit(CartError(failure.toString())), (_) {
      emit(CartCleared());
      add(LoadCartItems());
    });
  }
}
