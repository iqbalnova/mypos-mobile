import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/product_repository.dart';
import 'add_cart_item.dart';

class UpdateCartItem implements UseCase<CartItem, CartItemParams> {
  final ProductRepository repository;

  UpdateCartItem(this.repository);

  @override
  Future<Either<Failure, CartItem>> call(CartItemParams params) async {
    return await repository.updateCartItem(params.cartItem);
  }
}
