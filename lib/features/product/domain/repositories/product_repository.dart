import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/common/failure.dart';
import '../../data/models/product_form_model.dart';
import '../entities/category.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  // CATEGORY
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, void>> addCategory(String name);
  Future<Either<Failure, void>> updateCategory(String id, String name);
  Future<Either<Failure, void>> deleteCategory(String id);

  // PRODUCT
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, void>> addProduct(
    ProductFormModel formModel,
    File imageFile,
  );
  Future<Either<Failure, void>> updateProduct(
    String id,
    ProductFormModel formModel,
    File? imageFile,
  );
  Future<Either<Failure, void>> deleteProduct(String id);
}
