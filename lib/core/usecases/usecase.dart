import 'package:dartz/dartz.dart';
import 'package:ohrwurm/core/error/failures.dart';

abstract class UseCase<Entity, Params> {
  Future<Either<Failure, Entity>> call(Params params);
}
