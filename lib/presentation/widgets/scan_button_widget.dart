import 'package:flutter/material.dart';
import '../../core/utils/responsive_util.dart';

class ScanButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ScanButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: ResponsiveUtil.getResponsiveIconSize(context, baseSize: 28),
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveUtil.getResponsiveFontSize(
            context,
            baseFontSize: 18,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUtil.getResponsiveSpacing(
            context,
            baseSpacing: 20,
          ),
          horizontal: ResponsiveUtil.getResponsiveSpacing(
            context,
            baseSpacing: 24,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtil.getResponsiveBorderRadius(context),
          ),
        ),
      ),
    );
  }
}
