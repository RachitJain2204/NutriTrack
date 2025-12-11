import 'package:flutter/material.dart';
import '../theme/colors.dart';

class MealCard extends StatelessWidget {
  final String mealName;
  final String time;
  final int calories;
  final String macroSummary;
  final String imageAsset; // path to local image or empty for icon
  final VoidCallback? onTap;
  final double? radius;

  const MealCard({
    super.key,
    required this.mealName,
    required this.time,
    required this.calories,
    required this.macroSummary,
    this.imageAsset = '',
    this.onTap,
    this.radius = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    final thumb = imageAsset.isNotEmpty
        ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(imageAsset, width: 72, height: 72, fit: BoxFit.cover))
        : Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(Icons.fastfood, color: Colors.white70),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius!),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(radius!),
          border: Border.all(color: Colors.white12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 6, offset: const Offset(0,4))],
        ),
        child: Row(children: [
          thumb,
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(mealName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('$time • $macroSummary', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ),
          const SizedBox(width: 8),
          Column(children: [
            Text('$calories', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('kcal', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ]),
      ),
    );
  }
}
