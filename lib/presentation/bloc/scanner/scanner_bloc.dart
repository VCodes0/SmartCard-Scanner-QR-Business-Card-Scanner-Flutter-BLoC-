import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/usecases/scan_business_card_usecase.dart';
import '../../../domain/usecases/scan_qr_code_usecase.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

/// BLoC for handling scanner operations
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final ScanQRCodeUseCase scanQRCode;
  final ScanBusinessCardUseCase scanBusinessCard;

  ScannerBloc({required this.scanQRCode, required this.scanBusinessCard})
    : super(const ScannerInitial()) {
    on<ScanQRCodeEvent>(_onScanQRCode);
    on<ProcessQRDataEvent>(_onProcessQRData);
    on<ScanBusinessCardEvent>(_onScanBusinessCard);
    on<ResetScannerEvent>(_onResetScanner);
  }

  Future<void> _onScanQRCode(
    ScanQRCodeEvent event,
    Emitter<ScannerState> emit,
  ) async {
    emit(const ScannerLoading());
    // QR scanning happens in UI
    emit(const ScannerInitial());
  }

  Future<void> _onProcessQRData(
    ProcessQRDataEvent event,
    Emitter<ScannerState> emit,
  ) async {
    emit(const ScannerLoading());

    // Extract contact from QR code data
    final extractResult = await scanQRCode.repository.extractContactFromText(
      event.qrData,
    );

    extractResult.fold(
      (failure) => emit(ScannerError(failure.message)),
      (contact) => emit(ScannerSuccess(contact)),
    );
  }

  Future<void> _onScanBusinessCard(
    ScanBusinessCardEvent event,
    Emitter<ScannerState> emit,
  ) async {
    emit(const ScannerLoading());

    final result = await scanBusinessCard(NoParams());

    result.fold(
      (failure) => emit(ScannerError(failure.message)),
      (contact) => emit(ScannerSuccess(contact)),
    );
  }

  Future<void> _onResetScanner(
    ResetScannerEvent event,
    Emitter<ScannerState> emit,
  ) async {
    emit(const ScannerInitial());
  }
}
