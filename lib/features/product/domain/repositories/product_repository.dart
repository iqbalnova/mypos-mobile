import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../entities/category.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Category>>> getCategories();
}
