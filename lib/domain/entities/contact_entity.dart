import 'package:equatable/equatable.dart';

/// Contact entity representing a contact with all relevant information
class ContactEntity extends Equatable {
  final String? name;
  final String? phone;
  final String? email;
  final String? company;
  final String? jobTitle;
  final String? address;
  final String? website;
  final String? notes;

  const ContactEntity({
    this.name,
    this.phone,
    this.email,
    this.company,
    this.jobTitle,
    this.address,
    this.website,
    this.notes,
  });

  /// Check if the contact has at least some basic information
  bool get isValid =>
      (name != null && name!.isNotEmpty) ||
      (phone != null && phone!.isNotEmpty) ||
      (email != null && email!.isNotEmpty);

  /// Create a copy with updated fields
  ContactEntity copyWith({
    String? name,
    String? phone,
    String? email,
    String? company,
    String? jobTitle,
    String? address,
    String? website,
    String? notes,
  }) {
    return ContactEntity(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      address: address ?? this.address,
      website: website ?? this.website,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    company,
    jobTitle,
    address,
    website,
    notes,
  ];
}
