import 'package:equatable/equatable.dart';

/// Contact entity representing a contact with all relevant information
class ContactEntity extends Equatable {
  final String? name;
  final List<String>? phones;
  final List<String>? emails;
  final String? company;
  final String? jobTitle;
  final List<String>? addresses;
  final String? website;
  final String? notes;

  const ContactEntity({
    this.name,
    this.phones,
    this.emails,
    this.company,
    this.jobTitle,
    this.addresses,
    this.website,
    this.notes,
  });

  /// Check if the contact has at least some basic information
  bool get isValid =>
      (name != null && name!.isNotEmpty) ||
      (phones != null && phones!.isNotEmpty) ||
      (emails != null && emails!.isNotEmpty);

  /// Create a copy with updated fields
  ContactEntity copyWith({
    String? name,
    List<String>? phones,
    List<String>? emails,
    String? company,
    String? jobTitle,
    List<String>? addresses,
    String? website,
    String? notes,
  }) {
    return ContactEntity(
      name: name ?? this.name,
      phones: phones ?? this.phones,
      emails: emails ?? this.emails,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      addresses: addresses ?? this.addresses,
      website: website ?? this.website,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    name,
    phones,
    emails,
    company,
    jobTitle,
    addresses,
    website,
    notes,
  ];
}
