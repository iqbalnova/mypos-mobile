import 'package:dartz/dartz.dart';
import '../../../core/common/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
}
