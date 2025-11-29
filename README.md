# Contact Saver - Visiting Card Scanner

A Flutter application that scans visiting cards using the device camera, extracts contact information using Google ML Kit Text Recognition, and automatically opens the device contacts app with all extracted information prefilled.

## Features

- 📸 **Camera Integration**: Capture visiting card images using device camera or select from gallery
- 🔍 **OCR Text Recognition**: Extract text from visiting card images using Google ML Kit
- 📇 **Smart Data Extraction**: Automatically extracts:
  - Full name (non-numeric text)
  - Mobile numbers (+91 and 10-digit formats)
  - Telephone/landline numbers
  - Email addresses
  - Company names
  - Job titles
  - Website URLs
  - Address and additional notes
- 📱 **Contact Integration**: Automatically opens device contacts app with all extracted information prefilled
- 🎨 **Modern UI**: Clean, modern interface with smooth animations
- 🏗️ **Clean Architecture**: Well-structured codebase using GetX for state management
- ✅ **Null Safety**: Full null-safety support
- 🔒 **Permission Handling**: Proper permission requests for camera and photo library access

## Architecture

The app follows clean architecture principles with clear separation of concerns:

```
lib/
├── models/          # Data models (ContactData)
├── services/        # Business logic services
│   ├── camera_service.dart
│   ├── ocr_service.dart
│   └── contact_launcher_service.dart
├── controllers/     # GetX controllers for state management
│   └── home_controller.dart
├── screens/         # UI screens
│   └── home_screen.dart
└── main.dart        # App entry point
```

## Dependencies

- **get**: ^4.6.6 - State management and dependency injection
- **image_picker**: ^1.0.7 - Camera and gallery access
- **google_mlkit_text_recognition**: ^0.11.0 - OCR text recognition
- **url_launcher**: ^6.2.2 - Launching external apps (contacts)
- **permission_handler**: ^11.3.0 - Permission management
- **path_provider**: ^2.1.1 - File path utilities

## Permissions

### Android
- `CAMERA` - For capturing visiting card images
- `READ_MEDIA_IMAGES` - For accessing images from gallery (Android 13+)
- `READ_EXTERNAL_STORAGE` - For accessing images from gallery (Android 12 and below)
- `WRITE_EXTERNAL_STORAGE` - For saving images (Android 9 and below)

### iOS
- `NSCameraUsageDescription` - Camera access for scanning cards
- `NSPhotoLibraryUsageDescription` - Photo library access for selecting images
- `NSPhotoLibraryAddUsageDescription` - Permission to save images

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd save_card
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Usage

1. Launch the app
2. Tap the "Scan Visiting Card" button
3. Allow camera permission when prompted
4. Capture or select an image of a visiting card
5. Wait for OCR processing to extract contact information
6. The device contacts app will automatically open with all extracted information prefilled
7. Review and save the contact

## How It Works

1. **Image Capture**: User taps the scan button, and the app requests camera/gallery access
2. **OCR Processing**: The captured image is processed using Google ML Kit Text Recognition
3. **Data Extraction**: The OCR service parses the recognized text and extracts:
   - Names using pattern matching (non-numeric, letter-based text)
   - Phone numbers using regex patterns (Indian +91 format and 10-digit numbers)
   - Email addresses using email regex patterns
   - Company names by detecting company-related keywords
   - Job titles by detecting job-related keywords
   - Websites using URL patterns
4. **Contact Launch**: The extracted data is formatted and the device contacts app is opened with prefilled information

## Platform Support

- ✅ Android (API 21+)
- ✅ iOS (12.0+)

## Error Handling

The app includes comprehensive error handling for:
- Permission denials
- Camera/gallery access failures
- OCR processing errors
- Contact app launch failures

All errors are displayed to the user via snackbars and status messages.

## Performance Optimizations

- Efficient image processing with quality optimization
- Proper resource disposal (OCR recognizer cleanup)
- Reactive state management with GetX for smooth UI updates
- Optimized regex patterns for fast text extraction

## Future Enhancements

- Save contacts directly without opening external app
- Batch scanning multiple cards
- Contact history and management
- Export contacts to various formats
- Cloud sync capabilities
- Improved OCR accuracy with custom models

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
