import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features/company/domain/usecase/list_company_use_case.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../domain/entities/setting_point_entity.dart';
import '../../domain/enum/enum_data.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/usecase/setting_point_use_case.dart';
import '../company_choose_bloc.dart';
import 'work_space_state.dart';

@singleton
class WorkSpaceCubit extends Cubit<WorkSpaceState> {
  WorkSpaceCubit(
    this._listCompanyUseCase,
    this._settingPointUseCase,
    this._companyRepository,
  ) : super(const WorkSpaceState(isFirst: true));
  final delay = DelayCallBack(delay: 500.milliseconds);
  final ListCompanyUseCase _listCompanyUseCase;
  final SettingPointUseCase _settingPointUseCase;
  final CompanyRepository _companyRepository;

  Timer? timer;

  bool get isSort =>
      state.revenueFilter != null ||
      state.status != StatusWorkSpace.all ||
      state.type != null ||
      state.time != null;

  init() {
    emit(
      const WorkSpaceState(
        status: StatusWorkSpace.all,
        isFirst: true,
      ),
    );
    getListCompanies();
  }

  void changeFilter({
    StatusWorkSpace? status,
    String? type,
    TimeWorkSpace? time,
    RevenueWorkSpace? revenue,
    bool? isOwner,
    bool? isWorkingPlace,
  }) {
    emit(
      state.copyWith(
        status: status ?? StatusWorkSpace.all,
        type: type,
        time: time,
        revenueFilter: revenue,
        isOwner: isOwner ?? state.isOwner,
        isWorkingPlace: isWorkingPlace ?? state.isWorkingPlace,
      ),
    );
    getListCompanies();
  }

  Future<void> setComapny(int value) async {
    for (final element in state.companies) {
      if (element.id == value) {
        getIt<CompanyChooseBloc>().company = element;
        emit(state.copyWith(companyId: value));
        await setCompanyData(element);
        return;
      }
    }
  }

  changeSearchParent(String value) {
    emit(state.copyWith(search: value));
    delay.debounce(
      () => getListCompanies(
        parent: getCompany,
      ),
    );
  }

  setSearch(String value) {
    emit(state.copyWith(search: value));
    // delay.debounce(
    //   () => getListCompanies(),
    // );
    getListCompanies();
  }

  Future<void> getListCompanies({
    int? companyIdData,
    int? parent,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore && state.companies.length < state.limit) {
      return;
    }
    List<CompanyEntity> companies = state.companies;
    emit(state.copyWith(isLoading: true, isLoadMore: isLoadMore));
    final page = isLoadMore ? state.page + 1 : 1;
    int? companyId;

    final input = ListCompanyInput(
      page: page,
      limit: state.limit,
      parent: parent,
      search: state.search,
      revenue: state.revenueFilter,
      status: state.status,
      type: state.type,
      time: state.time,
      isOwner: state.isOwner,
      isWorkingPlace: state.isWorkingPlace,
    );

    final res = await _listCompanyUseCase.execute(input);

    for (final element in (res.response.data ?? [])) {
      if (element.id == companyIdData) {
        companyId = companyIdData;
      }
    }
    final data = res.response.data ?? [];

    if (isLoadMore) {
      companies += data;
    } else {
      companies = data;
    }

    emit(
      state.copyWith(
        companies: companies,
        isLoading: false,
        isLoadMore: false,
        isFirst: state.search.isEmptyOrNull && companies.isEmpty && !isSort,
        count: res.count,
        countWorking: res.countWorking,
        revenue: res.revenue,
        revenueBefore: res.revenueBefore,
        page: data.isEmpty ? page - 1 : page,
        companyId: companyId ?? state.companyId,
      ),
    );
  }

  Future<void> updateSettingPoint(SettingPointEntity settingPoint) async {
    final input = SettingPointUseCaseInput(
      payload: settingPoint.toJson(),
      idCompany: getCompany!,
    );
    final res = await _settingPointUseCase.execute(input);
    final list = List<CompanyEntity>.from(state.companies);
    final index = list.indexWhere((e) => e.id == state.companyId);
    list[index] = list[index].copyWith(
      settingPoint: () => res.response.data ?? list[index].settingPoint,
    );
    emit(state.copyWith(companies: list));
  }

  Future<void> getListPointExchangePackage() async {
    final res = await _companyRepository.listPointExchangePackage(
      ws: getCompanyId!,
    );
    emit(state.copyWith(listPointExchangePackage: res.data ?? []));
  }
}
