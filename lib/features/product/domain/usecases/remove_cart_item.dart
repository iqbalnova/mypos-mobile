import 'package:dartz/dartz.dart';

import '../../../core/common/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class RemoveCartItem implements UseCase<Unit, RemoveCartItemParams> {
  final ProductRepository repository;

  RemoveCartItem(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RemoveCartItemParams params) async {
    return await repository.removeCartItem(params.productId);
  }
}

class RemoveCartItemParams {
  final String productId;

  RemoveCartItemParams({required this.productId});
}
