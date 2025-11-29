import 'package:equatable/equatable.dart';
import '../../../domain/entities/contact_entity.dart';

/// Base class for all scanner states
abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ScannerInitial extends ScannerState {
  const ScannerInitial();
}

/// Loading state while scanning
class ScannerLoading extends ScannerState {
  const ScannerLoading();
}

/// Success state with extracted contact
class ScannerSuccess extends ScannerState {
  final ContactEntity contact;

  const ScannerSuccess(this.contact);

  @override
  List<Object?> get props => [contact];
}

/// Error state
class ScannerError extends ScannerState {
  final String message;

  const ScannerError(this.message);

  @override
  List<Object?> get props => [message];
}
