import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';

part 'service_detail_state.freezed.dart';

@freezed
class ServiceDetailState with _$ServiceDetailState {
  const factory ServiceDetailState({
    @Default(false) bool isLoading,
    ServiceEntity? service,
    @Default(<VariantEntity>[]) List<VariantEntity> variants,
  }) = _ServiceDetailState;
}

enum MenuDetailService {
  edit('Chỉnh sửa'),
  remove('Xoá');

  const MenuDetailService(this.name);
  final String name;
}
