import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> execute(String email, String password) {
    return repository.login(email, password);
  }
}
