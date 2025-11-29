import 'package:flutter/services.dart';
import '../../domain/entities/contact_entity.dart';

/// Service to launch native Android contact intent
class ContactIntentService {
  static const MethodChannel _channel = MethodChannel('contact_intent');

  /// Launch Android's Insert Contact Intent with pre-filled data
  static Future<void> launchAddContact(ContactEntity contact) async {
    try {
      final Map<String, dynamic> contactData = {
        'name': contact.name ?? '',
        'phones': contact.phones ?? [],
        'email': contact.email ?? '',
        'website': contact.website ?? '',
      };

      await _channel.invokeMethod('addContact', contactData);
    } on PlatformException catch (e) {
      throw Exception('Failed to launch contact intent: ${e.message}');
    }
  }
}
