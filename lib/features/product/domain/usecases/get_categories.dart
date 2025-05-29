import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../entities/category.dart';
import '../repositories/product_repository.dart';

class GetCategories {
  final ProductRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<Category>>> execute() {
    return repository.getCategories();
  }
}
