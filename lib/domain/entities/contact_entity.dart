import 'package:equatable/equatable.dart';

/// Contact entity with 4 essential fields from business card
class ContactEntity extends Equatable {
  final String? name;
  final List<String>? phones; // Max 2 phone numbers
  final String? email; // Single email only
  final String? website;

  const ContactEntity({this.name, this.phones, this.email, this.website});

  /// Check if the contact has at least some basic information
  bool get isValid =>
      (name != null && name!.isNotEmpty) ||
      (phones != null && phones!.isNotEmpty) ||
      (email != null && email!.isNotEmpty);

  /// Create a copy with updated fields
  ContactEntity copyWith({
    String? name,
    List<String>? phones,
    String? email,
    String? website,
  }) {
    return ContactEntity(
      name: name ?? this.name,
      phones: phones ?? this.phones,
      email: email ?? this.email,
      website: website ?? this.website,
    );
  }

  @override
  List<Object?> get props => [name, phones, email, website];
}
