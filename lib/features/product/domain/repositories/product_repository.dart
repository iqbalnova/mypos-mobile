import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../entities/category.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, void>> addCategory(String name);
  Future<Either<Failure, void>> updateCategory(String id, String name);
  Future<Either<Failure, void>> deleteCategory(String id);
}
