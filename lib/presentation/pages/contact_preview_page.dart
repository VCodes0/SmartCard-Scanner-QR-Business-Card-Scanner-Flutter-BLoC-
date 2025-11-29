import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/contact_entity.dart';
import '../bloc/contact/contact_bloc.dart';
import '../bloc/contact/contact_event.dart';
import '../bloc/contact/contact_state.dart';
import '../bloc/scanner/scanner_bloc.dart';
import '../bloc/scanner/scanner_event.dart';
import '../widgets/build_text_field.dart';

class ContactPreviewPage extends StatefulWidget {
  final ContactEntity contact;

  const ContactPreviewPage({super.key, required this.contact});

  @override
  State<ContactPreviewPage> createState() => _ContactPreviewPageState();
}

class _ContactPreviewPageState extends State<ContactPreviewPage> {
  late TextEditingController _nameController;
  late List<TextEditingController> _phoneControllers;
  late List<TextEditingController> _emailControllers;
  late TextEditingController _companyController;
  late TextEditingController _jobTitleController;
  late List<TextEditingController> _addressControllers;
  late TextEditingController _websiteController;
  late TextEditingController _notesController;

  bool _hasValidPhones = true;
  List<bool> _phoneValidationStatus = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name ?? '');

    // Initialize phone controllers from the phones list
    _phoneControllers = [];
    if (widget.contact.phones != null && widget.contact.phones!.isNotEmpty) {
      for (var phone in widget.contact.phones!) {
        _phoneControllers.add(TextEditingController(text: phone));
      }
    } else {
      // Add at least one empty controller if no phones
      _phoneControllers.add(TextEditingController());
    }

    // Initialize email controllers
    _emailControllers = [];
    if (widget.contact.emails != null && widget.contact.emails!.isNotEmpty) {
      for (var email in widget.contact.emails!) {
        _emailControllers.add(TextEditingController(text: email));
      }
    } else {
      _emailControllers.add(TextEditingController());
    }

    // Initialize address controllers
    _addressControllers = [];
    if (widget.contact.addresses != null &&
        widget.contact.addresses!.isNotEmpty) {
      for (var address in widget.contact.addresses!) {
        _addressControllers.add(TextEditingController(text: address));
      }
    } else {
      _addressControllers.add(TextEditingController());
    }

    _companyController = TextEditingController(
      text: widget.contact.company ?? '',
    );
    _jobTitleController = TextEditingController(
      text: widget.contact.jobTitle ?? '',
    );
    _websiteController = TextEditingController(
      text: widget.contact.website ?? '',
    );
    _notesController = TextEditingController(text: widget.contact.notes ?? '');

    // Validate phones on init
    _validatePhones();
  }

  void _validatePhones() {
    _phoneValidationStatus = _phoneControllers.map((controller) {
      final phone = controller.text.trim();
      final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
      return digits.length >= 10;
    }).toList();

    _hasValidPhones = _phoneValidationStatus.any((isValid) => isValid);
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _phoneControllers) {
      controller.dispose();
    }
    for (var controller in _emailControllers) {
      controller.dispose();
    }
    for (var controller in _addressControllers) {
      controller.dispose();
    }
    _companyController.dispose();
    _jobTitleController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveContact() {
    _validatePhones();

    if (!_hasValidPhones) {
      _showValidationDialog();
      return;
    }

    final List<String> phones = _phoneControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final List<String> emails = _emailControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final List<String> addresses = _addressControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final contact = ContactEntity(
      name: _nameController.text.trim(),
      phones: phones.isNotEmpty ? phones : null,
      emails: emails.isNotEmpty ? emails : null,
      company: _companyController.text.trim(),
      jobTitle: _jobTitleController.text.trim(),
      addresses: addresses.isNotEmpty ? addresses : null,
      website: _websiteController.text.trim(),
      notes: _notesController.text.trim(),
    );

    context.read<ContactBloc>().add(SaveContactEvent(contact));
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Invalid Phone Number'),
          ],
        ),
        content: const Text(
          'At least one phone number must have 10 or more digits. '
          'Please correct the phone numbers or scan the card again.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _retryScan();
            },
            child: const Text('Scan Retry'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Edit Manually'),
          ),
        ],
      ),
    );
  }

  void _retryScan() {
    // Reset scanner and navigate back
    context.read<ScannerBloc>().add(const ResetScannerEvent());
    Navigator.of(context).pop();
    // Trigger a new scan
    context.read<ScannerBloc>().add(const ScanBusinessCardEvent());
  }

  void _addPhoneField() {
    setState(() {
      _phoneControllers.add(TextEditingController());
      _phoneValidationStatus.add(false);
    });
  }

  void _removePhoneField(int index) {
    setState(() {
      _phoneControllers[index].dispose();
      _phoneControllers.removeAt(index);
      _phoneValidationStatus.removeAt(index);
    });
  }

  void _addEmailField() {
    setState(() {
      _emailControllers.add(TextEditingController());
    });
  }

  void _removeEmailField(int index) {
    setState(() {
      _emailControllers[index].dispose();
      _emailControllers.removeAt(index);
    });
  }

  void _addAddressField() {
    setState(() {
      _addressControllers.add(TextEditingController());
    });
  }

  void _removeAddressField(int index) {
    setState(() {
      _addressControllers[index].dispose();
      _addressControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Contact'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state is ContactSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contact saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back to home
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is ContactError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            final isSaving = state is ContactSaving;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Visual Card Preview
                  _buildCardPreview(),
                  const SizedBox(height: 24),

                  // Header Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: _hasValidPhones
                                ? Colors.green
                                : Colors.orange,
                            size: 48,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Information Extracted',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _hasValidPhones
                                      ? 'Review and edit the details below'
                                      : 'Please check phone numbers',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Editable Fields
                  buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),

                  // Phone Fields with validation indicators
                  ..._phoneControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    final isValid = index < _phoneValidationStatus.length
                        ? _phoneValidationStatus[index]
                        : false;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: controller,
                              label: 'Phone ${index + 1}',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                setState(() {
                                  _validatePhones();
                                });
                              },
                            ),
                          ),
                          if (!isValid)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 24,
                              ),
                            ),
                          if (_phoneControllers.length > 1)
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => _removePhoneField(index),
                            ),
                        ],
                      ),
                    );
                  }).toList(),

                  TextButton.icon(
                    onPressed: _addPhoneField,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Phone Number'),
                  ),
                  const SizedBox(height: 12),

                  // Email Fields
                  ..._emailControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: controller,
                              label: 'Email ${index + 1}',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          if (_emailControllers.length > 1)
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => _removeEmailField(index),
                            ),
                        ],
                      ),
                    );
                  }).toList(),

                  if (_emailControllers.isNotEmpty &&
                      _emailControllers.first.text.isNotEmpty)
                    TextButton.icon(
                      onPressed: _addEmailField,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Email'),
                    ),
                  const SizedBox(height: 12),

                  if (_companyController.text.isNotEmpty) ...[
                    buildTextField(
                      controller: _companyController,
                      label: 'Company',
                      icon: Icons.business_outlined,
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (_jobTitleController.text.isNotEmpty) ...[
                    buildTextField(
                      controller: _jobTitleController,
                      label: 'Job Title',
                      icon: Icons.work_outline,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Address Fields
                  ..._addressControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: controller,
                              label: 'Address ${index + 1}',
                              icon: Icons.location_on_outlined,
                              maxLines: 3,
                            ),
                          ),
                          if (_addressControllers.length > 1)
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => _removeAddressField(index),
                            ),
                        ],
                      ),
                    );
                  }).toList(),

                  if (_addressControllers.isNotEmpty &&
                      _addressControllers.first.text.isNotEmpty)
                    TextButton.icon(
                      onPressed: _addAddressField,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Address'),
                    ),
                  const SizedBox(height: 12),

                  if (_websiteController.text.isNotEmpty) ...[
                    buildTextField(
                      controller: _websiteController,
                      label: 'Website',
                      icon: Icons.language_outlined,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 12),
                  ],

                  buildTextField(
                    controller: _notesController,
                    label: 'Notes',
                    icon: Icons.note_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton.icon(
                    onPressed: isSaving ? null : _saveContact,
                    icon: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(isSaving ? 'Saving...' : 'Save to Contacts'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.credit_card,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Business Card Preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (widget.contact.name != null && widget.contact.name!.isNotEmpty)
              _buildPreviewRow(Icons.person, 'Name', widget.contact.name!),
            if (widget.contact.phones != null &&
                widget.contact.phones!.isNotEmpty)
              ...widget.contact.phones!.map((phone) {
                final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
                final isValid = digits.length >= 10;
                return _buildPreviewRow(
                  Icons.phone,
                  'Phone',
                  phone,
                  isValid: isValid,
                );
              }),
            if (widget.contact.emails != null &&
                widget.contact.emails!.isNotEmpty)
              ...widget.contact.emails!.map(
                (email) => _buildPreviewRow(Icons.email, 'Email', email),
              ),
            if (widget.contact.company != null &&
                widget.contact.company!.isNotEmpty)
              _buildPreviewRow(
                Icons.business,
                'Company',
                widget.contact.company!,
              ),
            if (widget.contact.jobTitle != null &&
                widget.contact.jobTitle!.isNotEmpty)
              _buildPreviewRow(
                Icons.work,
                'Job Title',
                widget.contact.jobTitle!,
              ),
            if (widget.contact.addresses != null &&
                widget.contact.addresses!.isNotEmpty)
              ...widget.contact.addresses!.map(
                (address) =>
                    _buildPreviewRow(Icons.location_on, 'Address', address),
              ),
            if (widget.contact.website != null &&
                widget.contact.website!.isNotEmpty)
              _buildPreviewRow(
                Icons.language,
                'Website',
                widget.contact.website!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow(
    IconData icon,
    String label,
    String value, {
    bool isValid = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isValid
                ? Theme.of(context).colorScheme.primary
                : Colors.orange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                  if (!isValid)
                    const TextSpan(text: ' ⚠️', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
