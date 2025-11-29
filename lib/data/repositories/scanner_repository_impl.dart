import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/scanner_repository.dart';
import '../datasources/scanner_data_source.dart';

/// Implementation of scanner repository
class ScannerRepositoryImpl implements ScannerRepository {
  final ScannerDataSource dataSource;

  ScannerRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, String>> scanQRCode() async {
    try {
      final result = await dataSource.scanQRCode();
      return Right(result);
    } on Exception catch (e) {
      return Left(ScannerFailure(e.toString()));
    } catch (e) {
      return Left(ScannerFailure('Unknown error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> scanBusinessCard() async {
    try {
      final result = await dataSource.scanBusinessCard();
      return Right(result);
    } on Exception catch (e) {
      return Left(ScannerFailure(e.toString()));
    } catch (e) {
      return Left(ScannerFailure('Unknown error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ContactEntity>> extractContactFromText(
    String text,
  ) async {
    try {
      final result = await dataSource.extractContactFromText(text);
      return Right(result);
    } on Exception catch (e) {
      return Left(ParseFailure(e.toString()));
    } catch (e) {
      return Left(ParseFailure('Unknown error occurred: ${e.toString()}'));
    }
  }
}
