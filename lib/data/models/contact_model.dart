import '../../domain/entities/contact_entity.dart';

/// Data model for Contact that extends the entity
class ContactModel extends ContactEntity {
  const ContactModel({super.name, super.phones, super.email, super.website});

  /// Convert from entity to model
  factory ContactModel.fromEntity(ContactEntity entity) {
    return ContactModel(
      name: entity.name,
      phones: entity.phones,
      email: entity.email,
      website: entity.website,
    );
  }

  /// Create from JSON
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json['name'] as String?,
      phones: (json['phones'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      email: json['email'] as String?,
      website: json['website'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'phones': phones, 'email': email, 'website': website};
  }
}
