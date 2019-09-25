import 'package:flutter/material.dart';

enum ContrastPreference {
  none,
  light,
  dark,
}

const double _kMinContrastModifierRange = 0.35;
const double _kMaxContrastModifierRange = 0.65;

/// Returns black or white depending on whether the source color is darker
/// or lighter. If darker, will return white. If lighter, will return
/// black. If the color is within 35-65% of the spectrum and a prefer
/// value is specified, then white or black will be preferred.
Color blackOrWhiteContrastColor(Color sourceColor,
    {ContrastPreference prefer = ContrastPreference.none}) {
  // Will return a value between 0.0 (black) and 1.0 (white)
  final double value = (((sourceColor.red * 299.0) +
              (sourceColor.green * 587.0) +
              (sourceColor.blue * 114.0)) /
          1000.0) /
      255.0;
  if (prefer != ContrastPreference.none) {
    if (value >= _kMinContrastModifierRange &&
        value <= _kMaxContrastModifierRange) {
      return prefer == ContrastPreference.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF000000);
    }
  }
  return value > 0.6 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
}
