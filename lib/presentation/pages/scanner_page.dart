import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/utils/responsive_util.dart';
import '../bloc/scanner/scanner_bloc.dart';
import '../bloc/scanner/scanner_event.dart';

enum ScanType { qrCode, businessCard }

class ScannerPage extends StatefulWidget {
  final ScanType scanType;

  const ScannerPage({super.key, required this.scanType});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  MobileScannerController? _cameraController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.scanType == ScanType.qrCode) {
      _cameraController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _cameraController?.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _cameraController?.stop();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  void _handleQRDetection(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? qrData = barcodes.first.rawValue;
    if (qrData == null || qrData.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Trigger the bloc event to process QR data and extract contact
      if (mounted) {
        context.read<ScannerBloc>().add(ProcessQRDataEvent(qrData));
        // Navigate back - the BLoC listener on HomePage will handle navigation to preview
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing QR code: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.scanType == ScanType.qrCode
              ? 'Scan QR Code'
              : 'Scan Business Card',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: widget.scanType == ScanType.qrCode
          ? _buildQRScanner()
          : _buildBusinessCardInfo(),
    );
  }

  Widget _buildQRScanner() {
    return Stack(
      children: [
        MobileScanner(
          controller: _cameraController,
          onDetect: _handleQRDetection,
        ),

        // Overlay with scanning area
        LayoutBuilder(
          builder: (context, constraints) {
            final scanAreaSize = ResponsiveUtil.getResponsiveIconSize(
              context,
              baseSize: 250,
            );
            return Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: Center(
                child: Container(
                  width: scanAreaSize,
                  height: scanAreaSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtil.getResponsiveBorderRadius(context),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Instructions
        Positioned(
          bottom: ResponsiveUtil.getResponsiveSpacing(
            context,
            baseSpacing: 100,
          ),
          left: 0,
          right: 0,
          child: Padding(
            padding: ResponsiveUtil.getHorizontalPadding(context),
            child: Card(
              child: Padding(
                padding: ResponsiveUtil.getResponsivePadding(context),
                child: Text(
                  'Position the QR code within the frame',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: ResponsiveUtil.getResponsiveFontSize(
                      context,
                      baseFontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessCardInfo() {
    return Center(
      child: Padding(
        padding: ResponsiveUtil.getResponsivePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.credit_card_rounded,
              size: ResponsiveUtil.getResponsiveIconSize(context, baseSize: 80),
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(
              height: ResponsiveUtil.getResponsiveSpacing(
                context,
                baseSpacing: 24,
              ),
            ),
            Text(
              'Business Card Scanner',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveUtil.getResponsiveFontSize(
                  context,
                  baseFontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveUtil.getResponsiveSpacing(
                context,
                baseSpacing: 16,
              ),
            ),
            Text(
              'The camera will open to capture the business card. '
              'Make sure the card is well-lit and all text is clearly visible.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: ResponsiveUtil.getResponsiveFontSize(
                  context,
                  baseFontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveUtil.getResponsiveSpacing(
                context,
                baseSpacing: 32,
              ),
            ),
            const CircularProgressIndicator(),
            SizedBox(
              height: ResponsiveUtil.getResponsiveSpacing(
                context,
                baseSpacing: 16,
              ),
            ),
            Text(
              'Opening camera...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveUtil.getResponsiveFontSize(
                  context,
                  baseFontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
