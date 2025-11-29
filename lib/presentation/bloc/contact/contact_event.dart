import 'package:equatable/equatable.dart';
import '../../../domain/entities/contact_entity.dart';

/// Base class for all contact events
abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

/// Event to save a contact
class SaveContactEvent extends ContactEvent {
  final ContactEntity contact;

  const SaveContactEvent(this.contact);

  @override
  List<Object?> get props => [contact];
}

/// Event to check contact permission
class CheckPermissionEvent extends ContactEvent {
  const CheckPermissionEvent();
}

/// Event to request contact permission
class RequestPermissionEvent extends ContactEvent {
  const RequestPermissionEvent();
}

/// Event to reset contact state
class ResetContactEvent extends ContactEvent {
  const ResetContactEvent();
}
