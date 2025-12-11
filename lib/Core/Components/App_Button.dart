import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final Color? color;
  final double? radius;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.color,
    this.radius = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primaryGreen;
    return ElevatedButton(
      onPressed: loading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius!)),
        elevation: 4,
      ),
      child: loading
          ? const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : Text(label, style: AppText.body1.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}
