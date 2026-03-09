import 'package:flutter/material.dart';
class IndicatorImg extends StatelessWidget {
  const IndicatorImg({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSelected ? 24 : 8,
      height: 8,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E1E3)),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
