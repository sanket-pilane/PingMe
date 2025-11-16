import 'package:flutter/material.dart';
import 'package:pingme/app/app_colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.darkBorder, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Or', style: Theme.of(context).textTheme.bodyMedium),
        ),
        const Expanded(
          child: Divider(color: AppColors.darkBorder, thickness: 1),
        ),
      ],
    );
  }
}
