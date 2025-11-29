import 'package:equatable/equatable.dart';

/// Base class for all scanner events
abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object?> get props => [];
}

/// Event to scan a QR code
class ScanQRCodeEvent extends ScannerEvent {
  final String qrData;

  const ScanQRCodeEvent(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

/// Event to process QR data and extract contact
class ProcessQRDataEvent extends ScannerEvent {
  final String qrData;

  const ProcessQRDataEvent(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

/// Event to scan a business card
class ScanBusinessCardEvent extends ScannerEvent {
  const ScanBusinessCardEvent();
}

/// Event to reset scanner state
class ResetScannerEvent extends ScannerEvent {
  const ResetScannerEvent();
}
