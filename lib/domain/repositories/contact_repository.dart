import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/contact_entity.dart';

/// Contact repository interface
/// Defines all contact-related operations
abstract class ContactRepository {
  /// Save a contact to the device
  Future<Either<Failure, bool>> saveContact(ContactEntity contact);

  /// Check if contacts permission is granted
  Future<Either<Failure, bool>> checkContactPermission();

  /// Request contacts permission
  Future<Either<Failure, bool>> requestContactPermission();
}
