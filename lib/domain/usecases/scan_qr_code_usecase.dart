import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../repositories/scanner_repository.dart';

/// Use case for scanning QR codes
class ScanQRCodeUseCase extends UseCase<String, NoParams> {
  final ScannerRepository repository;

  ScanQRCodeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.scanQRCode();
  }
}
