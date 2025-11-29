import 'package:equatable/equatable.dart';

/// Base class for all contact states
abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ContactInitial extends ContactState {
  const ContactInitial();
}

/// Loading state while saving
class ContactSaving extends ContactState {
  const ContactSaving();
}

/// Success state after saving
class ContactSaved extends ContactState {
  const ContactSaved();
}

/// Error state
class ContactError extends ContactState {
  final String message;

  const ContactError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Permission granted state
class PermissionGranted extends ContactState {
  const PermissionGranted();
}

/// Permission denied state
class PermissionDenied extends ContactState {
  const PermissionDenied();
}
