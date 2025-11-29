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
      String? phone;
      String? email;
      String? company;
      String? jobTitle;
      String? address;
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
      ];

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        // Extract email
        if (email == null && emailPattern.hasMatch(line)) {
          email = emailPattern.firstMatch(line)?.group(0);
          continue;
        }

        // Extract phone
        if (phone == null && phonePattern.hasMatch(line)) {
          final match = phonePattern.firstMatch(line)?.group(0);
          if (match != null &&
              match.replaceAll(RegExp(r'[^0-9]'), '').length >= 10) {
            phone = match;
            continue;
          }
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

        // First non-special line is likely the name
        if (name == null &&
            !emailPattern.hasMatch(line) &&
            !phonePattern.hasMatch(line) &&
            !websitePattern.hasMatch(line)) {
          name = line;
          continue;
        }

        // Second non-special line might be company
        if (name != null &&
            company == null &&
            !emailPattern.hasMatch(line) &&
            !phonePattern.hasMatch(line) &&
            !websitePattern.hasMatch(line) &&
            jobTitle != line) {
          company = line;
        }
      }

      // If we still don't have a name, use the first line
      name ??= lines.isNotEmpty ? lines[0] : null;

      return ContactModel(
        name: name,
        phone: phone,
        email: email,
        company: company,
        jobTitle: jobTitle,
        address: address,
        website: website,
        notes: 'Scanned from business card',
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
