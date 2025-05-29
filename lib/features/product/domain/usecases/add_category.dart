import 'package:dartz/dartz.dart';

import '../../../core/common/failure.dart';
import '../repositories/product_repository.dart';

class AddCategory {
  final ProductRepository repository;

  AddCategory(this.repository);

  Future<Either<Failure, void>> execute(String name) {
    return repository.addCategory(name);
  }
}
