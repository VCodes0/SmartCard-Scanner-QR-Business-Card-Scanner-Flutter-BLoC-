import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/contact_entity.dart';
import '../repositories/scanner_repository.dart';

/// Use case for scanning business cards
class ScanBusinessCardUseCase extends UseCase<ContactEntity, NoParams> {
  final ScannerRepository repository;

  ScanBusinessCardUseCase(this.repository);

  @override
  Future<Either<Failure, ContactEntity>> call(NoParams params) async {
    // First scan the card to get raw text
    final scanResult = await repository.scanBusinessCard();

    return scanResult.fold((failure) => Left(failure), (text) async {
      // Then extract contact information from the text
      return await repository.extractContactFromText(text);
    });
  }
}
