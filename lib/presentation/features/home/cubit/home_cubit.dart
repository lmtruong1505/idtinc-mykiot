import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/notification/domain/usecase/notification_list_use_case.dart';
import 'package:pharmago/presentation/features/report/domain/usecase/report_customer_use_case.dart';
import 'package:pharmago/presentation/features/report/domain/usecase/report_home_use_case.dart';
import 'package:pharmago/presentation/features/report/domain/usecase/report_order_use_case.dart';
import 'package:pharmago/presentation/features/report/domain/usecase/report_revenue_use_case.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../base/bottom_bar.dart';
import '../../company/domain/entities/company_entity.dart';
import '../../report/domain/usecase/report_customer_revenue_use_case.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._reportHomeUseCase,
    this._notificationListUseCase,
    this._reportRevenueUseCase,
    this._reportOrderUseCase,
    this._reportCustomerUseCase,
    this._reportCustomerRevenueUseCase,
    // this._getStoreInfoUseCase,
    // this._orderTotalCountUseCase,
    // this._customerGetListUseCase,
    // this._dashBoardGetUseCase,
  ) : super(HomeState());

  // final GetStoreInfoUseCase _getStoreInfoUseCase;
  // final OrderTotalCountUseCase _orderTotalCountUseCase;
  // final CustomerGetListUseCase _customerGetListUseCase;
  // final DashBoardGetUseCase _dashBoardGetUseCase;
  final NotificationListUseCase _notificationListUseCase;
  final ReportHomeUseCase _reportHomeUseCase;
  final ReportRevenueUseCase _reportRevenueUseCase;
  final ReportOrderUseCase _reportOrderUseCase;
  final ReportCustomerUseCase _reportCustomerUseCase;
  final ReportCustomerRevenueUseCase _reportCustomerRevenueUseCase;

  late WebSocketChannel? _socketChannel;

  // void initSocket() => _socketConect();

  // void disposeSocket() => _socketChannel?.sink.close(status.goingAway);

  Future<void> _socketConect() async {
    try {
      final company = getCompany;
      final uri = Uri.parse('ws://167.71.206.14:8000/websocket/$company');
      _socketChannel = WebSocketChannel.connect(uri);
      await _socketChannel?.ready;
      _socketChannel?.stream.listen((message) {
        final data = jsonDecode(message);
        if (data['company']['Int32'] == company) {
          listNoti();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  final List<HomeFuncEntity> listFunc = [
    const HomeFuncEntity(
      title: 'Đơn bán hàng',
      icon: '/ic_func_sale.svg',
      page: LoginRoute(),
    ),
    const HomeFuncEntity(
      title: 'Đơn đặt hàng',
      icon: '/ic_func_order.svg',
      page: LoginRoute(),
    ),
    const HomeFuncEntity(
      title: 'Quản lý sản phẩm',
      icon: '/ic_func_manage_product.svg',
      page: LoginRoute(),
    ),
    const HomeFuncEntity(
      title: 'Quản lý khách hàng',
      icon: '/ic_func_manage_customer.svg',
      page: LoginRoute(),
    ),
    const HomeFuncEntity(
      title: 'Sản phẩm Mykiot',
      icon: '/ic_app.svg',
      page: LoginRoute(),
    ),
  ];

  void init(List<CompanyEntity> companies) {
    final name =
        AppSharedPreference.instance.getValue(PrefKeys.userFullName) as String?;
    final companyMenuItem = companies
        .map(
          (e) => DropdownMenuItem<int>(
            value: e.id,
            child: Text(
              e.name ?? 'Chưa có thông tin',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
    emit(
      state.copyWith(
        timeStart: DateTime.now(),
        accountName: name ?? '',
        companies: companyMenuItem,
        companySelected: getCompany,
      ),
    );
  }

  void companyChange(int? value) {
    AppSharedPreference.instance.setValue(PrefKeys.company, value);
    emit(state.copyWith(companySelected: value));
  }

  void onPageChange(TabCode page) {
    emit(state.copyWith(pageSelected: page));
  }

  void onViewChange(bool value) {
    emit(state.copyWith(viewReportOrderDone: value));
  }

  Future<void> reportHome() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return;
    final input = ReportHomeInput(company);
    final res = await _reportHomeUseCase.execute(input);
    emit(state.copyWith(homeReport: res.response.data));
  }

  Future<void> listNoti() async {
    final company = getCompany;
    if (company == null) return;
    final input = NotificationListInput(
      company: company,
      page: 1,
      limit: 200,
    );
    final res = await _notificationListUseCase.execute(input);
    emit(state.copyWith(countNotiNotSeen: res.response.extra ?? 0));
  }

  Future<void> reportRevenue() async {
    final input = ReportRevenueInput(
      company: getCompany!,
      filter: 'MONTH',
    );
    final res = await _reportRevenueUseCase.execute(input);

    emit(
      state.copyWith(
        revenueItems: res.response.data ?? [],
        currentRevenue:
            double.tryParse(res.response.extra['current_value'].toString()) ??
                0,
        lastRevenue:
            double.tryParse(res.response.extra['last_value'].toString()) ?? 0,
      ),
    );
  }

  String percentDifferent(double current, double last) {
    try {
      if (current > last) {
        if (last == 0) return '+100';
        return '+${((current / last) * 100 - 100).toStringAsFixed(1)}';
      } else {
        if (current == 0) return '-100';
        return '-${((last / current) * 100 - 100).toStringAsFixed(1)}';
      }
    } catch (e) {
      return '0';
    }
  }

  Future<void> getReportOrder() async {
    try {
      final company = getCompany;
      if (company == null) return;
      final input = ReportOrderInput(company: company, filter: 'MONTH');
      final res = await _reportOrderUseCase.execute(input);
      emit(
        state.copyWith(
          currentOrder: res.response.extra['current_value'] as int? ?? 0,
          lastOrder: res.response.extra['last_value'] as int? ?? 0,
        ),
      );
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> getReportCustomer() async {
    try {
      final company = getCompany;
      if (company == null) return;
      final input = ReportCustomerInput(company: company);
      final res = await _reportCustomerUseCase.execute(input);
      emit(
        state.copyWith(
          currentCustomer: res.response.extra['current_value'] as int? ?? 0,
          lastCustomer: res.response.extra['last_value'] as int? ?? 0,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  void filterOrderByChange(FilterCustomerRevenueReport value) {
    emit(state.copyWith(orderBy: value));
    getReportCustomerRevenue();
  }

  Future<void> getReportCustomerRevenue() async {
    emit(state.copyWith(isLoadingReportCustomerRevenue: true));
    final input = ReportCustomerRevenueInput(
      company: getCompany!,
      filter: state.orderBy.value,
    );
    final res = await _reportCustomerRevenueUseCase.execute(input);
    emit(
      state.copyWith(
        customerRevenueReport: res.response.data,
        isLoadingReportCustomerRevenue: false,
      ),
    );
  }
}
