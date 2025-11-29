import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_data_source.dart';

/// Implementation of contact repository
class ContactRepositoryImpl implements ContactRepository {
  final ContactDataSource dataSource;

  ContactRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, bool>> saveContact(ContactEntity contact) async {
    try {
      final result = await dataSource.saveContact(contact);
      return Right(result);
    } on Exception catch (e) {
      return Left(ContactFailure(e.toString()));
    } catch (e) {
      return Left(ContactFailure('Unknown error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkContactPermission() async {
    try {
      final result = await dataSource.checkContactPermission();
      return Right(result);
    } on Exception catch (e) {
      return Left(PermissionFailure(e.toString()));
    } catch (e) {
      return Left(PermissionFailure('Unknown error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> requestContactPermission() async {
    try {
      final result = await dataSource.requestContactPermission();
      return Right(result);
    } on Exception catch (e) {
      return Left(PermissionFailure(e.toString()));
    } catch (e) {
      return Left(PermissionFailure('Unknown error occurred: ${e.toString()}'));
    }
  }
}
