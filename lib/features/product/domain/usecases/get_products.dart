import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> execute() {
    return repository.getProducts();
  }
}
