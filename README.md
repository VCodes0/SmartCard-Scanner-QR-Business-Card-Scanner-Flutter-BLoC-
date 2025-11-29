# Contact Saver

A powerful Flutter mobile application that simplifies contact management by scanning QR codes and business cards to automatically extract and save contact information. Built with **Clean Architecture** and **BLoC** pattern for robustness and scalability.

## 🚀 Features

-   **Smart Scanning**:
    -   **QR Codes**: Instantly scan vCard QR codes to parse contact details.
    -   **Business Cards**: Use AI-powered OCR (Google ML Kit) to scan physical business cards and intelligently extract names, emails, phone numbers, and more.
-   **Automatic Extraction**: Advanced regex patterns identify and categorize contact fields (Name, Job Title, Phone, Email, Website, Address).
-   **One-Tap Save**: Seamlessly save extracted details directly to your device's native Contacts app.
-   **Onboarding Experience**: Beautiful, animated onboarding flow for first-time users.
-   **Lifecycle Management**: Efficient resource handling (camera pauses when app is backgrounded).
-   **Privacy Focused**: All processing happens on-device; no data is sent to external servers.

## 🛠️ Tech Stack

-   **Framework**: Flutter (Dart)
-   **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
-   **Architecture**: Clean Architecture (Presentation, Domain, Data, Core)
-   **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
-   **OCR & Vision**: [google_mlkit_text_recognition](https://pub.dev/packages/google_mlkit_text_recognition)
-   **QR Scanning**: [mobile_scanner](https://pub.dev/packages/mobile_scanner)
-   **Contacts**: [flutter_contacts](https://pub.dev/packages/flutter_contacts)
-   **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)

## 🏗️ Architecture

The project follows **Clean Architecture** principles to ensure separation of concerns and testability:

```
lib/
├── core/                   # Core utilities (Error handling, DI, Services)
├── domain/                 # Business logic (Entities, UseCases, Repository Interfaces)
├── data/                   # Data layer (Models, Data Sources, Repository Implementations)
└── presentation/           # UI layer (Pages, Widgets, BLoCs)
```

### Key Components
-   **BLoC**: Manages state for Scanning (`ScannerBloc`) and Contact operations (`ContactBloc`).
-   **UseCases**: Encapsulate specific business rules (e.g., `ScanQRCodeUseCase`, `SaveContactUseCase`).
-   **Repositories**: Abstract data sources, allowing easy switching between implementations.

## 📱 Setup & Installation

### Prerequisites
-   Flutter SDK (3.0+)
-   Android Studio / Xcode
-   Physical device (recommended for Camera testing)

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/contact_saver.git
    cd contact_saver
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the app**:
    ```bash
    flutter run
    ```

### Permissions

The app requires the following permissions, which are already configured:

**Android** (`AndroidManifest.xml`):
-   `CAMERA`: For scanning.
-   `READ_CONTACTS` / `WRITE_CONTACTS`: To save extracted details.
-   `INTERNET`: Required by ML Kit to download OCR models (once).

**iOS** (`Info.plist`):
-   `NSCameraUsageDescription`
-   `NSContactsUsageDescription`
-   `NSMicrophoneUsageDescription` (Safety fallback)

## 📖 Usage Guide

1.  **Onboarding**: On first launch, swipe through the introduction to understand the app's capabilities.
2.  **Home Screen**: Choose your scanning mode:
    -   **Scan QR Code**: Point at a vCard QR code.
    -   **Scan Business Card**: Capture a clear photo of a visiting card.
3.  **Preview & Edit**: Review the extracted information. You can manually edit any field if the OCR missed something.
4.  **Save**: Tap "Save Contact" to add it to your phonebook.

## 🔄 App Lifecycle

The app implements `WidgetsBindingObserver` to manage resources efficiently:
-   **Resumed**: Camera preview restarts automatically.
-   **Paused/Inactive**: Camera resources are released to save battery and memory.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
