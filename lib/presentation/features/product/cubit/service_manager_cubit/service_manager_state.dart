import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/count_entity.dart';

part 'service_manager_state.freezed.dart';

@freezed
class ServiceManagerState with _$ServiceManagerState {
  const factory ServiceManagerState({
    @Default('') String search,
    @Default(10) int limit,
    @Default(ServiceStatus.values) List<ServiceStatus> listFilter,
    @Default(ServiceStatus.all) ServiceStatus selectFilter,
    @Default(<CountEntity>[]) List<CountEntity> serviceCount,
  }) = _ServiceManagerState;
}

enum ServiceStatus {
  all(title: 'Tất cả', code: 'ALL'),
  active(title: 'Đang bán', code: 'TRUE'),
  inactive(title: 'Đã ẩn', code: 'FALSE');

  final String title;
  final String code;
  const ServiceStatus({
    required this.title,
    required this.code,
  });
}
