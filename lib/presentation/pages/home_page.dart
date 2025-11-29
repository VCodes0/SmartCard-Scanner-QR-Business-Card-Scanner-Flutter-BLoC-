import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/responsive_util.dart';
import '../bloc/scanner/scanner_bloc.dart';
import '../bloc/scanner/scanner_event.dart';
import '../bloc/scanner/scanner_state.dart';
import '../widgets/scan_button_widget.dart';
import '../../core/services/contact_intent_service.dart';
import 'scanner_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Saver'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<ScannerBloc, ScannerState>(
        listener: (context, state) async {
          if (state is ScannerSuccess) {
            // Launch native Android contact intent with pre-filled data
            try {
              await ContactIntentService.launchAddContact(state.contact);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error opening contacts: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } else if (state is ScannerError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            // Reset scanner
            context.read<ScannerBloc>().add(const ResetScannerEvent());
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ResponsiveUtil.getMaxContentWidth(context),
                      ),
                      child: Padding(
                        padding: ResponsiveUtil.getResponsivePadding(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // App Icon
                            Icon(
                              Icons.contact_phone_rounded,
                              size: ResponsiveUtil.getResponsiveIconSize(
                                context,
                                baseSize: 120,
                              ),
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: ResponsiveUtil.getResponsiveSpacing(
                                context,
                                baseSpacing: 24,
                              ),
                            ),

                            // Title
                            Text(
                              'Scan & Save Contacts',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        ResponsiveUtil.getResponsiveFontSize(
                                          context,
                                          baseFontSize: 28,
                                        ),
                                  ),
                            ),
                            SizedBox(
                              height: ResponsiveUtil.getResponsiveSpacing(
                                context,
                                baseSpacing: 12,
                              ),
                            ),

                            // Subtitle
                            Text(
                              'Quickly scan QR codes or business cards to save contact information',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize:
                                        ResponsiveUtil.getResponsiveFontSize(
                                          context,
                                          baseFontSize: 16,
                                        ),
                                  ),
                            ),
                            SizedBox(
                              height: ResponsiveUtil.getResponsiveSpacing(
                                context,
                                baseSpacing: 48,
                              ),
                            ),

                            // Scan QR Code Button
                            ScanButton(
                              icon: Icons.qr_code_scanner_rounded,
                              label: 'Scan QR Code',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ScannerPage(
                                      scanType: ScanType.qrCode,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: ResponsiveUtil.getResponsiveSpacing(
                                context,
                                baseSpacing: 16,
                              ),
                            ),

                            // Scan Business Card Button
                            ScanButton(
                              icon: Icons.credit_card_rounded,
                              label: 'Scan Business Card',
                              onPressed: () {
                                context.read<ScannerBloc>().add(
                                  const ScanBusinessCardEvent(),
                                );
                              },
                            ),
                            SizedBox(
                              height: ResponsiveUtil.getResponsiveSpacing(
                                context,
                                baseSpacing: 32,
                              ),
                            ),

                            // Info Card
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveUtil.getResponsiveBorderRadius(
                                    context,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: ResponsiveUtil.getResponsivePadding(
                                  context,
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      size:
                                          ResponsiveUtil.getResponsiveIconSize(
                                            context,
                                            baseSize: 32,
                                          ),
                                    ),
                                    SizedBox(
                                      height:
                                          ResponsiveUtil.getResponsiveSpacing(
                                            context,
                                            baseSpacing: 12,
                                          ),
                                    ),
                                    Text(
                                      'How it works',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                ResponsiveUtil.getResponsiveFontSize(
                                                  context,
                                                  baseFontSize: 18,
                                                ),
                                          ),
                                    ),
                                    SizedBox(
                                      height:
                                          ResponsiveUtil.getResponsiveSpacing(
                                            context,
                                            baseSpacing: 8,
                                          ),
                                    ),
                                    Text(
                                      '1. Choose scan type\n'
                                      '2. Scan QR code or business card\n'
                                      '3. Review extracted information\n'
                                      '4. Save to your contacts',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize:
                                                ResponsiveUtil.getResponsiveFontSize(
                                                  context,
                                                  baseFontSize: 14,
                                                ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
