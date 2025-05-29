import 'package:dartz/dartz.dart';

import '../../../core/common/failure.dart';
import '../repositories/product_repository.dart';

class DeleteCategory {
  final ProductRepository repository;

  DeleteCategory(this.repository);

  Future<Either<Failure, void>> execute(String id) {
    return repository.deleteCategory(id);
  }
}
