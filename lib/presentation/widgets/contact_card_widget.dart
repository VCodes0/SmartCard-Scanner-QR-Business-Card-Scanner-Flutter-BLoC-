import 'package:flutter/material.dart';
import '../../domain/entities/contact_entity.dart';

class ContactCard extends StatelessWidget {
  final ContactEntity contact;

  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contact.name != null && contact.name!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.person_outline,
                label: 'Name',
                value: contact.name!,
                context: context,
              ),
            if (contact.phone != null && contact.phone!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: contact.phone!,
                context: context,
              ),
            if (contact.email != null && contact.email!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: contact.email!,
                context: context,
              ),
            if (contact.company != null && contact.company!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.business_outlined,
                label: 'Company',
                value: contact.company!,
                context: context,
              ),
            if (contact.jobTitle != null && contact.jobTitle!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.work_outline,
                label: 'Job Title',
                value: contact.jobTitle!,
                context: context,
              ),
            if (contact.address != null && contact.address!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: contact.address!,
                context: context,
              ),
            if (contact.website != null && contact.website!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.language_outlined,
                label: 'Website',
                value: contact.website!,
                context: context,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
