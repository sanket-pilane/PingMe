import 'package:flutter/material.dart';
import 'package:pingme/app/app_colors.dart';

class DoctolibLogo extends StatelessWidget {
  final double size;
  final Color color;
  const DoctolibLogo({
    super.key,
    this.size = 36,
    this.color = AppColors.textWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.add_box_rounded, color: color, size: size),
        const SizedBox(width: 8),
        Text(
          'Doctolib',
          style: TextStyle(
            fontSize: size * 0.9,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
