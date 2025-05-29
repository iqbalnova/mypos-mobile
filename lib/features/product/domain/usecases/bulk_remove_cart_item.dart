import 'package:dartz/dartz.dart';

import '../../../core/common/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class BulkRemoveCartItem implements UseCase<Unit, BulkRemoveCartItemParams> {
  final ProductRepository repository;

  BulkRemoveCartItem(this.repository);

  @override
  Future<Either<Failure, Unit>> call(BulkRemoveCartItemParams params) async {
    return await repository.bulkRemoveCartItems(params.productIds);
  }
}

class BulkRemoveCartItemParams {
  final List<String> productIds;

  BulkRemoveCartItemParams({required this.productIds});
}
