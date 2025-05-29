import 'package:dartz/dartz.dart';

import '../../../core/common/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class ClearCart implements UseCase<Unit, NoParams> {
  final ProductRepository repository;

  ClearCart(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.clearCart();
  }
}
