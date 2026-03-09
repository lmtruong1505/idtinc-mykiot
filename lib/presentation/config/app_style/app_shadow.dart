part of 'init_app_style.dart';

class AppShadows {
  AppShadows._();

  static final elevator0 = [
    BoxShadow(
      blurRadius: 0,
      spreadRadius: 0,
      offset: const Offset(0, -1),
      color: AppColors.blackAlpha5,
    ),
    BoxShadow(
      blurRadius: 0,
      spreadRadius: 0,
      offset: const Offset(0, 1),
      color: AppColors.blackAlpha5,
    ),
    BoxShadow(
      blurRadius: 0,
      spreadRadius: 0,
      offset: const Offset(-1, 0),
      color: AppColors.blackAlpha5,
    ),
    BoxShadow(
      blurRadius: 0,
      spreadRadius: 0,
      offset: const Offset(1, 0),
      color: AppColors.blackAlpha5,
    ),
  ];

  static final elevator1 = [
    BoxShadow(
      blurRadius: 4,
      spreadRadius: -2,
      offset: const Offset(0, 2),
      color: AppColors.blackAlpha20,
    ),
    BoxShadow(
      blurRadius: 3,
      spreadRadius: 0,
      offset: const Offset(0, 1),
      color: AppColors.blackAlpha15,
    ),
  ];

  static final elevator3 = [
    BoxShadow(
      blurRadius: 8,
      spreadRadius: -2,
      offset: const Offset(0, 3),
      color: AppColors.blackAlpha15,
    ),
    BoxShadow(
      blurRadius: 6,
      spreadRadius: -1,
      offset: const Offset(0, 4),
      color: AppColors.black.withOpacity(0.03),
    ),
  ];
}
