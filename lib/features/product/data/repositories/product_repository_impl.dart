import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/common/exception.dart';
import '../../../core/common/failure.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/cart_item_model.dart';
import '../models/product_form_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Category
  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(String name) async {
    try {
      await remoteDataSource.addCategory(name);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(String id, String name) async {
    try {
      await remoteDataSource.updateCategory(id, name);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await remoteDataSource.deleteCategory(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  // Product
  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final result = await remoteDataSource.getProducts();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(
    ProductFormModel formModel,
    File imageFile,
  ) async {
    try {
      await remoteDataSource.addProduct(formModel, imageFile);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(
    String id,
    ProductFormModel formModel,
    File? imageFile,
  ) async {
    try {
      await remoteDataSource.updateProduct(id, formModel, imageFile);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  // CART
  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final cartItems = await localDataSource.getCartItems();
      return Right(cartItems);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartItem>> addCartItem(CartItem cartItem) async {
    try {
      final cartItemModel = CartItemModel.fromEntity(cartItem);
      final result = await localDataSource.addCartItem(cartItemModel);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartItem>> updateCartItem(CartItem cartItem) async {
    try {
      final cartItemModel = CartItemModel.fromEntity(cartItem);
      final result = await localDataSource.updateCartItem(cartItemModel);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeCartItem(String productId) async {
    try {
      await localDataSource.removeCartItem(productId);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> bulkRemoveCartItems(
    List<String> productIds,
  ) async {
    try {
      await localDataSource.bulkRemoveCartItems(productIds);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalPrice() async {
    try {
      final cartItems = await localDataSource.getCartItems();
      final totalPrice = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );
      return Right(totalPrice);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalItems() async {
    try {
      final cartItems = await localDataSource.getCartItems();
      final totalItems = cartItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );
      return Right(totalItems);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
