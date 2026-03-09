import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../authentication/domain/entities/account_entity.dart';
import '../../data/models/point_exchange_package_model.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/setting_point_entity.dart';
import '../../domain/enum/enum_data.dart';

part 'work_space_state.freezed.dart';

@freezed
class WorkSpaceState with _$WorkSpaceState {
  const factory WorkSpaceState({
    @Default(false) bool isFirst,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadMore,
    @Default(100) int limit,
    @Default(1) int page,
    @Default([]) List<CompanyEntity> companies,
    @Default([]) List<PointExchangePackageModel> listPointExchangePackage,
    @Default(0) int? count,
    @Default(0) int? countWorking,
    @Default(0) double? revenue,
    @Default(0) double? revenueBefore,
    TimeWorkSpace? time,
    StatusWorkSpace? status,
    RevenueWorkSpace? revenueFilter,
    AccountEntity? account,
    String? search,
    String? type,
    int? companyId,
    //lấy công ty đang sở hữu
    @Default(true) bool isOwner,
    //lấy công ty đang làm việc
    @Default(false) bool isWorkingPlace,
  }) = _WorkSpaceState;
}

extension GetWorkSpaceState on WorkSpaceState {
  CompanyEntity? get company {
    if (companyId == null) return null;
    return companies.firstWhere((e) => e.id == companyId);
  }

  SettingPointEntity? get settingPoint {
    return company?.settingPoint;
  }
}
