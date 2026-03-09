import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';

part 'branch_detail_state.freezed.dart';

@freezed
class BranchDetailState with _$BranchDetailState {
  const factory BranchDetailState({
    @Default(false) bool isLoading,
    @Default('Không tìm thấy thông tin cơ sở này') String message,
    CompanyEntity? company,
  }) = _BranchDetailState;
}

enum MenuDetailBranch {
  disable('Vô hiệu hóa'),
  active('Kích hoạt'),
  edit('Chỉnh sửa'),
  remove('Xoá');

  const MenuDetailBranch(this.name);
  final String name;
}
