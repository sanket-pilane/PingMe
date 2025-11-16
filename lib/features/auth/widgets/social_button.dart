import 'package:flutter/material.dart';
import 'package:pingme/app/app_colors.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const SocialButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
      child: Icon(icon, color: AppColors.textLightGrey, size: 24),
    );
  }
}
