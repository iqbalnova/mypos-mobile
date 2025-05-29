import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/product_repository.dart';

class AddCartItem implements UseCase<CartItem, CartItemParams> {
  final ProductRepository repository;

  AddCartItem(this.repository);

  @override
  Future<Either<Failure, CartItem>> call(CartItemParams params) async {
    return await repository.addCartItem(params.cartItem);
  }
}

class CartItemParams {
  final CartItem cartItem;

  CartItemParams({required this.cartItem});
}
