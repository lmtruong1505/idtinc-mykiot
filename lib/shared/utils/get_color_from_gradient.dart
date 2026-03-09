import 'package:flutter/material.dart';

// Color getColorFromGradient(
//   double percent,
//   List<Color> colors, {
//   List<double> stops = const [0.0, 1.0],
// }) {
//   print(colors.length);
//   if (percent <= 0) return colors.first;
//   if (percent >= 1) return colors.last;

//   for (int i = 0; i < stops.length - 1; i++) {
//     if (percent >= stops[i] && percent <= stops[i + 1]) {
//       final double t = (percent - stops[i]) / (stops[i + 1] - stops[i]);
//       return Color.lerp(colors[i], colors[i + 1], t)!;
//     }
//   }
//   return colors.last;
// }

Color getColorFromGradient(
  double percentage,
  List<Color> gradientColors, {
  List<double> stops = const [0.0, 1.0],
}) {
  if (percentage <= 0) return gradientColors.first;
  if (percentage >= 1) return gradientColors.last;

  if (gradientColors.length == 1) {
    return gradientColors.first;
  }

  double segment = 1.0 / (gradientColors.length - 1);
  int index = (percentage / segment).floor();
  double localPercentage = (percentage - (segment * index)) / segment;

  ColorTween colorTween =
      ColorTween(begin: gradientColors[index], end: gradientColors[index + 1]);
  return colorTween.transform(localPercentage)!;
}
