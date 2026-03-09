part of 'init_app_style.dart';

abstract class AppStyle {
  static const FontWeight _LIGHT = FontWeight.w300;
  static const FontWeight _DEFAULT = FontWeight.w400;
  static const FontWeight _MEDIUM = FontWeight.w500;
  static const FontWeight _SEMIBOLD = FontWeight.w600;
  static const FontWeight _BOLD = FontWeight.w700;

  static TextStyle headingDisplay = const TextStyle(
    height: 1.5,
    fontSize: 32,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle heading3xl = const TextStyle(
    height: 1.5,
    fontSize: 28,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle heading2xl = const TextStyle(
    height: 1.5,
    fontSize: 24,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle headingXl = const TextStyle(
    height: 1.5,
    fontSize: 20,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle headingLg = const TextStyle(
    height: 1.5,
    fontSize: 18,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle headingMd = const TextStyle(
    height: 1.5,
    fontSize: 16,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle headingBs = const TextStyle(
    height: 1.5,
    fontSize: 14,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyMdRegular = const TextStyle(
    height: 1.5,
    fontSize: 16,
    fontWeight: _DEFAULT,
    color: AppColors.text_primary,
  );

  static TextStyle bodyMdMedium = const TextStyle(
    height: 1.5,
    fontSize: 16,
    fontWeight: _MEDIUM,
    color: AppColors.text_primary,
  );

  static TextStyle bodyMdSemiBold = const TextStyle(
    height: 1.5,
    fontSize: 16,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyMdBold = const TextStyle(
    height: 1.5,
    fontSize: 16,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyBsRegular = const TextStyle(
    height: 1.5,
    fontSize: 14,
    fontWeight: _DEFAULT,
    color: AppColors.text_primary,
  );

  static TextStyle bodyBsMedium = const TextStyle(
    height: 1.5,
    fontSize: 14,
    fontWeight: _MEDIUM,
    color: AppColors.text_primary,
  );

  static TextStyle bodyBsSemiBold = const TextStyle(
    height: 1.5,
    fontSize: 14,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyBsBold = const TextStyle(
    height: 1.5,
    fontSize: 14,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodySmRegular = const TextStyle(
    height: 1.5,
    fontSize: 12,
    fontWeight: _DEFAULT,
    color: AppColors.text_primary,
  );

  static TextStyle bodySmMedium = const TextStyle(
    height: 1.5,
    fontSize: 12,
    fontWeight: _MEDIUM,
    color: AppColors.text_primary,
  );

  static TextStyle bodySmSemiBold = const TextStyle(
    height: 1.5,
    fontSize: 12,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodySmBold = const TextStyle(
    height: 1.5,
    fontSize: 12,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyXsRegular = const TextStyle(
    height: 1.5,
    fontSize: 10,
    fontWeight: _DEFAULT,
    color: AppColors.text_primary,
  );

  static TextStyle bodyXsMedium = const TextStyle(
    height: 1.5,
    fontSize: 10,
    fontWeight: _MEDIUM,
    color: AppColors.text_primary,
  );

  static TextStyle bodyXsSemiBold = const TextStyle(
    height: 1.5,
    fontSize: 10,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyXsBold = const TextStyle(
    height: 1.5,
    fontSize: 10,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle light({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      height: 1.5,
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _LIGHT,
      decoration: decoration,
    );
  }

  static TextStyle normal({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      height: 1.5,
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _DEFAULT,
      decoration: decoration,
    );
  }

  static TextStyle medium({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      height: 1.5,
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _MEDIUM,
      decoration: decoration,
    );
  }

  static TextStyle semibold({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      height: 1.5,
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _SEMIBOLD,
      decoration: decoration,
    );
  }

  static TextStyle bold({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      height: 1.5,
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _BOLD,
      decoration: decoration,
    );
  }
}

const FontWeight LIGHT = FontWeight.w300;
const FontWeight DEFAULT = FontWeight.w400;
const FontWeight MEDIUM = FontWeight.w500;
const FontWeight MEDIUM2 = FontWeight.w600;
const FontWeight BOLD = FontWeight.w700;

const TextStyle s30w700 = TextStyle(
  height: 1.5,
  fontSize: 30,
  fontWeight: BOLD,
);

const TextStyle s24w700 = TextStyle(
  height: 1.5,
  fontSize: 24,
  fontWeight: BOLD,
);

const TextStyle s20w700 = TextStyle(
  height: 1.5,
  fontSize: 20,
  fontWeight: BOLD,
);
const TextStyle s20w500 = TextStyle(
  height: 1.5,
  fontSize: 20,
  fontWeight: DEFAULT,
);

const TextStyle s18w700 = TextStyle(
  height: 1.5,
  fontSize: 18,
  fontWeight: BOLD,
);
const TextStyle s18w500 = TextStyle(
  height: 1.5,
  fontSize: 18,
  fontWeight: MEDIUM,
);

const TextStyle s18w400 = TextStyle(
  height: 1.5,
  fontSize: 18,
  fontWeight: DEFAULT,
);

const TextStyle s16w700 = TextStyle(
  height: 1.5,
  fontSize: 16,
  fontWeight: BOLD,
);
const TextStyle s16w500 = TextStyle(
  height: 1.5,
  fontSize: 16,
  fontWeight: MEDIUM,
);

const TextStyle s16w400 = TextStyle(
  height: 1.5,
  fontSize: 16,
  fontWeight: DEFAULT,
);

const TextStyle s16w300 = TextStyle(
  height: 1.5,
  fontSize: 16,
  fontWeight: LIGHT,
);

const TextStyle s14w700 = TextStyle(
  height: 1.5,
  fontSize: 14,
  fontWeight: BOLD,
);
const TextStyle s14w600 = TextStyle(
  height: 1.5,
  fontSize: 14,
  fontWeight: MEDIUM2,
);

const TextStyle s14w500 = TextStyle(
  height: 1.5,
  fontSize: 14,
  fontWeight: MEDIUM,
);

const TextStyle s14w400 = TextStyle(
  height: 1.5,
  fontSize: 14,
  fontWeight: DEFAULT,
);

const TextStyle s12w500 = TextStyle(
  height: 1.5,
  fontSize: 12,
  fontWeight: MEDIUM,
);

const TextStyle s12w700 = TextStyle(
  height: 1.5,
  fontSize: 12,
  fontWeight: BOLD,
);
const TextStyle s12w600 = TextStyle(
  height: 1.5,
  fontSize: 12,
  fontWeight: MEDIUM2,
);

const TextStyle s12w400 = TextStyle(
  height: 1.5,
  fontSize: 12,
  fontWeight: DEFAULT,
);
const TextStyle s10w700 = TextStyle(
  height: 1.5,
  fontSize: 10,
  fontWeight: BOLD,
);
const TextStyle s10w400 = TextStyle(
  height: 1.5,
  fontSize: 10,
  fontWeight: DEFAULT,
);
const TextStyle s10w500 = TextStyle(
  height: 1.5,
  fontSize: 10,
  fontWeight: MEDIUM,
);

const TextStyle s8w400 = TextStyle(
  height: 1.5,
  fontSize: 8,
  fontWeight: DEFAULT,
);
const TextStyle s8w700 = TextStyle(
  height: 1.5,
  fontSize: 8,
  fontWeight: BOLD,
);
