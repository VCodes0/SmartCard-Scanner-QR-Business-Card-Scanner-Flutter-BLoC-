import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/contact_entity.dart';
import '../models/contact_model.dart';

/// Abstract interface for scanner data source
abstract class ScannerDataSource {
  Future<String> scanQRCode();
  Future<String> scanBusinessCard();
  Future<ContactEntity> extractContactFromText(String text);
}

/// Implementation of scanner data source
class ScannerDataSourceImpl implements ScannerDataSource {
  final ImagePicker _imagePicker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  Future<String> scanQRCode() async {
    // This will be handled by the UI using MobileScanner widget
    // The actual scanning happens in the presentation layer
    // This method is here for architectural completeness
    throw UnimplementedError(
      'QR scanning happens in the presentation layer using MobileScanner widget',
    );
  }

  @override
  Future<String> scanBusinessCard() async {
    try {
      // Pick image from camera
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image == null) {
        throw Exception('No image captured');
      }

      // Process image with ML Kit
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      // Combine all text blocks
      final String extractedText = recognizedText.blocks
          .map((block) => block.text)
          .join('\n');

      if (extractedText.isEmpty) {
        throw Exception('No text detected in the image');
      }

      return extractedText;
    } catch (e) {
      throw Exception('Failed to scan business card: ${e.toString()}');
    }
  }

  @override
  Future<ContactEntity> extractContactFromText(String text) async {
    try {
      String? name;
      List<String> phones = [];
      List<String> emails = [];
      String? company;
      String? jobTitle;
      List<String> addresses = [];
      String? website;

      // Split text into lines
      final lines = text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      // Email regex pattern
      final emailPattern = RegExp(
        r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
      );

      // Phone regex pattern (supports various formats)
      // Changed to capture ALL phone numbers, not just 10+ digits
      final phonePattern = RegExp(
        r'(\+?\d{1,4}[\s-]?)?(\(?\d{2,4}\)?[\s-]?)?\d{3,4}[\s-]?\d{3,4}',
      );

      // Website regex pattern
      final websitePattern = RegExp(
        r'(https?://)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}',
      );

      // Common job titles for detection
      final jobTitles = [
        'CEO',
        'CTO',
        'CFO',
        'COO',
        'Manager',
        'Director',
        'Developer',
        'Engineer',
        'Designer',
        'Consultant',
        'Analyst',
        'Specialist',
        'Coordinator',
        'Administrator',
        'Executive',
        'President',
        'VP',
        'Vice President',
        'Senior',
        'Junior',
        'Lead',
        'Head of',
        'Founder',
        'Managing Director',
      ];

      // Keywords that indicate an address line
      final addressKeywords = RegExp(
        r'(Street|St|Avenue|Ave|Road|Rd|Lane|Ln|Drive|Dr|Boulevard|Blvd|Way|Floor|Gf|Plot|A-|A1-|Building|Complex|Village|City|State|District|Dist|Pin|Pincode|India|Maharashtra|Thane|Mumbai)',
        caseSensitive: false,
      );

      List<String> potentialAddressLines = [];

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        // Extract all emails
        if (emailPattern.hasMatch(line)) {
          final matches = emailPattern.allMatches(line);
          for (final match in matches) {
            final emailStr = match.group(0);
            if (emailStr != null && !emails.contains(emailStr)) {
              emails.add(emailStr);
            }
          }
          continue;
        }

        // Extract ALL phone numbers (no minimum digit requirement)
        if (phonePattern.hasMatch(line)) {
          final matches = phonePattern.allMatches(line);
          for (final match in matches) {
            final phoneStr = match.group(0);
            if (phoneStr != null && !phones.contains(phoneStr)) {
              phones.add(phoneStr);
            }
          }
          // Don't continue - the line might have other info
        }

        // Extract website
        if (website == null && websitePattern.hasMatch(line)) {
          website = websitePattern.firstMatch(line)?.group(0);
          continue;
        }

        // Extract job title
        if (jobTitle == null) {
          for (var title in jobTitles) {
            if (line.toLowerCase().contains(title.toLowerCase())) {
              jobTitle = line;
              break;
            }
          }
        }

        // Detect potential address lines
        if (addressKeywords.hasMatch(line) ||
            (line.contains(RegExp(r'\d')) && line.length > 10)) {
          potentialAddressLines.add(line);
          continue;
        }

        // First non-special line is likely the name
        if (name == null &&
            !emailPattern.hasMatch(line) &&
            !websitePattern.hasMatch(line) &&
            line.length < 50) {
          // Names are typically short
          name = line;
          continue;
        }

        // Second non-special line might be company
        if (name != null &&
            company == null &&
            !emailPattern.hasMatch(line) &&
            !websitePattern.hasMatch(line) &&
            jobTitle != line &&
            line.length < 100) {
          company = line;
        }
      }

      // Group address lines into complete addresses
      // Check for keywords like "FACTORY ADD:", "OFFICE ADD:", etc.
      String currentAddress = '';
      for (var i = 0; i < potentialAddressLines.length; i++) {
        final line = potentialAddressLines[i];

        // Check if this line starts a new address section
        if (line.toUpperCase().contains('ADD:') ||
            line.toUpperCase().contains('ADDRESS') ||
            (i > 0 &&
                currentAddress.isNotEmpty &&
                (line.contains(RegExp(r'^[A-Z]')) && line.contains('-')))) {
          // Save previous address if exists
          if (currentAddress.isNotEmpty) {
            addresses.add(currentAddress.trim());
            currentAddress = '';
          }
          currentAddress = line;
        } else {
          // Add to current address
          if (currentAddress.isEmpty) {
            currentAddress = line;
          } else {
            currentAddress += ', ' + line;
          }
        }
      }

      // Add the last address
      if (currentAddress.isNotEmpty) {
        addresses.add(currentAddress.trim());
      }

      // If we still don't have a name, use the first line
      name ??= lines.isNotEmpty ? lines[0] : null;

      return ContactModel(
        name: name,
        phones: phones.isNotEmpty ? phones : null,
        emails: emails.isNotEmpty ? emails : null,
        company: company,
        jobTitle: jobTitle,
        addresses: addresses.isNotEmpty ? addresses : null,
        website: website,
        notes: 'Write Any Notes For This Contact If You Want 😀',
      );
    } catch (e) {
      throw Exception('Failed to extract contact information: ${e.toString()}');
    }
  }

  /// Dispose resources
  void dispose() {
    _textRecognizer.close();
  }
}
