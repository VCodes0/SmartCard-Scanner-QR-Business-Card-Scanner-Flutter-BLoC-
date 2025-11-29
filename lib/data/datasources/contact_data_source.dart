import 'package:flutter_contacts/flutter_contacts.dart';
import '../../domain/entities/contact_entity.dart';

/// Abstract interface for contact data source
abstract class ContactDataSource {
  Future<bool> saveContact(ContactEntity contact);
  Future<bool> checkContactPermission();
  Future<bool> requestContactPermission();
}

/// Implementation of contact data source
class ContactDataSourceImpl implements ContactDataSource {
  @override
  Future<bool> saveContact(ContactEntity contact) async {
    try {
      // Check permission first
      final hasPermission = await checkContactPermission();

      if (!hasPermission) {
        final granted = await requestContactPermission();
        if (!granted) {
          throw Exception('Contacts permission denied');
        }
      }

      // Create new contact
      final newContact = Contact()
        ..name.first = _extractFirstName(contact.name ?? '')
        ..name.last = _extractLastName(contact.name ?? '');

      // Add phones if available
      if (contact.phones != null && contact.phones!.isNotEmpty) {
        newContact.phones = contact.phones!
            .map((phone) => Phone(phone, label: PhoneLabel.mobile))
            .toList();
      }

      // Add emails if available
      if (contact.emails != null && contact.emails!.isNotEmpty) {
        newContact.emails = contact.emails!
            .map((email) => Email(email, label: EmailLabel.work))
            .toList();
      }

      // Add company/organization if available
      if (contact.company != null && contact.company!.isNotEmpty) {
        newContact.organizations = [
          Organization(
            company: contact.company!,
            title: contact.jobTitle ?? '',
          ),
        ];
      }

      // Add addresses if available
      if (contact.addresses != null && contact.addresses!.isNotEmpty) {
        newContact.addresses = contact.addresses!
            .map((address) => Address(address, label: AddressLabel.work))
            .toList();
      }

      // Add website if available
      if (contact.website != null && contact.website!.isNotEmpty) {
        newContact.websites = [
          Website(contact.website!, label: WebsiteLabel.work),
        ];
      }

      // Add notes if available
      if (contact.notes != null && contact.notes!.isNotEmpty) {
        newContact.notes = [Note(contact.notes!)];
      }

      // Insert the contact
      await newContact.insert();

      return true;
    } catch (e) {
      throw Exception('Failed to save contact: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkContactPermission() async {
    try {
      final permission = await FlutterContacts.requestPermission(
        readonly: false,
      );
      return permission;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> requestContactPermission() async {
    try {
      final permission = await FlutterContacts.requestPermission(
        readonly: false,
      );
      return permission;
    } catch (e) {
      return false;
    }
  }

  /// Extract first name from full name
  String _extractFirstName(String fullName) {
    if (fullName.isEmpty) return '';
    final parts = fullName.trim().split(' ');
    return parts.first;
  }

  /// Extract last name from full name
  String _extractLastName(String fullName) {
    if (fullName.isEmpty) return '';
    final parts = fullName.trim().split(' ');
    if (parts.length > 1) {
      return parts.sublist(1).join(' ');
    }
    return '';
  }
}
