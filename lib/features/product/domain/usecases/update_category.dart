import 'package:dartz/dartz.dart';

import '../../../core/common/failure.dart';
import '../repositories/product_repository.dart';

class UpdateCategory {
  final ProductRepository repository;

  UpdateCategory(this.repository);

  Future<Either<Failure, void>> execute(String id, String name) {
    return repository.updateCategory(id, name);
  }
}
