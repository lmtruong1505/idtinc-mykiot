import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/packaging_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/count_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/unit_entity.dart';
import 'package:pharmago/presentation/features/product/screens/product_manager_page.dart';


part 'product_manager_state.freezed.dart';

@freezed
class ProductManagerState with _$ProductManagerState {
  const factory ProductManagerState({
    @Default(TabProductManagerPage.product) TabProductManagerPage tabSelected,
    @Default('') String search,
    @Default(10) int limit,
    @Default(<PackagingEntity>[]) List<PackagingEntity> packaging,
    UnitEntity? unit,
    @Default(ProductStatus.values) List<ProductStatus> listFilter,
    @Default(ProductStatus.all) ProductStatus selectFilter,
    @Default(<CountEntity>[]) List<CountEntity> productCount,
  }) = _ProductManagerState;
}

enum ProductStatus {
  all(title: 'Tất cả', code: 'ALL'),
  active(title: 'Đang bán', code: 'TRUE'),
  inactive(title: 'Đã ẩn', code: 'FALSE');

  final String title;
  final String code;
  const ProductStatus({
    required this.title,
    required this.code,
  });
}
