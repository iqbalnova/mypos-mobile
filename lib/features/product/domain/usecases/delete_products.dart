import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<Either<Failure, void>> execute(String id) {
    return repository.deleteProduct(id);
  }
}
