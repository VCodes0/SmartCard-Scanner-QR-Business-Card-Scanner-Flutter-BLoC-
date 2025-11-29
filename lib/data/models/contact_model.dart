import '../../domain/entities/contact_entity.dart';

/// Data model for Contact that extends the entity
class ContactModel extends ContactEntity {
  const ContactModel({
    super.name,
    super.phone,
    super.email,
    super.company,
    super.jobTitle,
    super.address,
    super.website,
    super.notes,
  });

  /// Convert from entity to model
  factory ContactModel.fromEntity(ContactEntity entity) {
    return ContactModel(
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      company: entity.company,
      jobTitle: entity.jobTitle,
      address: entity.address,
      website: entity.website,
      notes: entity.notes,
    );
  }

  /// Create from JSON
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      company: json['company'] as String?,
      jobTitle: json['jobTitle'] as String?,
      address: json['address'] as String?,
      website: json['website'] as String?,
      notes: json['notes'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'company': company,
      'jobTitle': jobTitle,
      'address': address,
      'website': website,
      'notes': notes,
    };
  }
}
