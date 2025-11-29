import '../../domain/entities/contact_entity.dart';

/// Data model for Contact that extends the entity
class ContactModel extends ContactEntity {
  const ContactModel({
    super.name,
    super.phones,
    super.emails,
    super.company,
    super.jobTitle,
    super.addresses,
    super.website,
    super.notes,
  });

  /// Convert from entity to model
  factory ContactModel.fromEntity(ContactEntity entity) {
    return ContactModel(
      name: entity.name,
      phones: entity.phones,
      emails: entity.emails,
      company: entity.company,
      jobTitle: entity.jobTitle,
      addresses: entity.addresses,
      website: entity.website,
      notes: entity.notes,
    );
  }

  /// Create from JSON
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json['name'] as String?,
      phones: (json['phones'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      emails: (json['emails'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      company: json['company'] as String?,
      jobTitle: json['jobTitle'] as String?,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      website: json['website'] as String?,
      notes: json['notes'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phones': phones,
      'emails': emails,
      'company': company,
      'jobTitle': jobTitle,
      'addresses': addresses,
      'website': website,
      'notes': notes,
    };
  }
}
