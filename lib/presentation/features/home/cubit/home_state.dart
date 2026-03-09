import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/report/domain/entities/home_report_entity.dart';

import '../../../base/bottom_bar.dart';
import '../../report/domain/entities/customer_report_revenue_entity.dart';
import '../../report/domain/entities/revenue_report_entity.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    // @Default(StoreEntity()) StoreEntity storeEntity,
    @Default(true) bool isLoading,
    @Default(0) int orderCount,
    @Default(0) int customerCount,
    int? companySelected,
    @Default(TabCode.home) TabCode pageSelected,
    @Default(true) bool viewReportOrderDone,
    @Default('') String accountName,
    DateTime? timeStart,
    DateTime? timeEnd,
    HomeReportEntity? homeReport,
    @Default(0) int countNotiNotSeen,
    @Default(<DropdownMenuItem<int>>[]) List<DropdownMenuItem<int>> companies,
    @Default([]) List<RevenueReportEntity> revenueItems,  
    @Default(0) double currentRevenue,
    @Default(0) double lastRevenue,
    @Default(0) int currentOrder,
    @Default(0) int lastOrder,
    @Default(0) int currentCustomer,
    @Default(0) int lastCustomer,
    ReportCustomerRevenueEntity? customerRevenueReport,
    @Default(false) bool isLoadingReportCustomerRevenue,
    @Default(FilterCustomerRevenueReport.byQuantity) FilterCustomerRevenueReport orderBy,
  }) = _HomeState;
}

@freezed
class HomeFuncEntity with _$HomeFuncEntity {
  const HomeFuncEntity._();

  const factory HomeFuncEntity({
    @Default('') String icon,
    @Default('') String title,
    PageRouteInfo? page,
  }) = _HomeFuncEntity;
}

enum FilterCustomerRevenueReport {
  byQuantity('QUANTITY', 'Theo số lượng đơn'),
  byRevenue('REVENUE', 'Theo doanh số');

  final String value;
  final String title;
  const FilterCustomerRevenueReport(this.value, this.title);
}
