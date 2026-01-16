import 'package:community/core/error/failure.dart';
import 'package:community/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();
}