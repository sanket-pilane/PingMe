import 'package:flutter/material.dart';
import 'package:pingme/app/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // <-- make nullable

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed, // <-- allow null
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.6 : 1.0, // visual disabled effect
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: MaterialButton(
          onPressed: onPressed, // <-- null disables button automatically
          minWidth: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: Theme.of(context).textTheme.labelLarge),
        ),
      ),
    );
  }
}
