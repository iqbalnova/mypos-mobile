import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/product_repository.dart';

class GetCartItems implements UseCase<List<CartItem>, NoParams> {
  final ProductRepository repository;

  GetCartItems(this.repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(NoParams params) async {
    return await repository.getCartItems();
  }
}
