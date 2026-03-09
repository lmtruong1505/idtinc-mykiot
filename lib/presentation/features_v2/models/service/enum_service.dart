part of 'service.dart';

enum StatusServiceV2Enum {
  all(isActive: null, title: 'Tất cả'),
  active(isActive: true, title: 'Đang hoạt động'),
  inactive(isActive: false, title: 'Không hoạt động');

  final bool? isActive;
  final String title;

  const StatusServiceV2Enum({required this.isActive, required this.title});
}


