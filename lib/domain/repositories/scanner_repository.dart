import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/contact_entity.dart';

/// Scanner repository interface
/// Defines all scanner-related operations
abstract class ScannerRepository {
  /// Scan a QR code and return the raw string data
  Future<Either<Failure, String>> scanQRCode();

  /// Scan a business card using the camera and OCR
  Future<Either<Failure, String>> scanBusinessCard();

  /// Extract contact information from raw text
  Future<Either<Failure, ContactEntity>> extractContactFromText(String text);
}
